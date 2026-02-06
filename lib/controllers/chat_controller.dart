import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../utils/invoice_pdf_helper.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/scheduler.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../utils/pusher_constants.dart';

class ChatThread {
  final String id;
  final String title;
  final String lastMessage;
  final String timeLabel;
  final String avatarPath;
  final String otherUserId;
  final String productId;
  final String productSellerId;
  final int unreadCount;

  const ChatThread({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timeLabel,
    required this.avatarPath,
    required this.otherUserId,
    required this.productId,
    required this.productSellerId,
    this.unreadCount = 0,
  });

  ChatThread copyWith({
    String? title,
    String? lastMessage,
    String? timeLabel,
    String? avatarPath,
    int? unreadCount,
  }) {
    return ChatThread(
      id: id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      timeLabel: timeLabel ?? this.timeLabel,
      avatarPath: avatarPath ?? this.avatarPath,
      otherUserId: otherUserId,
      productId: productId,
      productSellerId: productSellerId,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  static String normalizeAvatarPath(String path) {
    if (path.isEmpty || path == 'null') return '';
    if (path.startsWith('lib/')) return path;

    String normalized = path.trim();

    // 1. Correct localhost and double-storage artifacts immediately
    if (normalized.contains('localhost')) {
      // Standardize any variation of localhost back to the production API root
      // Handle patterns like http://localhost/project/public/storage/...
      normalized = normalized.replaceFirst(
        RegExp(r'https?://localhost/[^/]+/[^/]+/storage/'),
        ApiConstants.imageBaseUrl,
      );
      normalized = normalized.replaceFirst(
        RegExp(r'https?://localhost/[^/]+/storage/'),
        ApiConstants.imageBaseUrl,
      );
      normalized = normalized.replaceFirst(
        RegExp(r'https?://localhost/storage/'),
        ApiConstants.imageBaseUrl,
      );

      if (normalized.contains('localhost')) {
        normalized = normalized.replaceFirst(
          RegExp(r'https?://localhost'),
          'https://ourworks.co.in/agro-connect/public',
        );
      }
    }

    if (normalized.startsWith('http')) {
      // Cleanup double storage or public/storage duplication
      normalized = normalized.replaceAll('/storage/storage/', '/storage/');
      normalized = normalized.replaceAll(
        '/public/public/storage/',
        '/public/storage/',
      );
      return normalized;
    }

    // 2. Defensive check for relative storage paths
    String cleanPath = normalized;
    while (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    final String base = ApiConstants.imageBaseUrl;
    // Strip common server prefixes that indicate the path is already from root
    if (cleanPath.startsWith('public/storage/')) {
      cleanPath = cleanPath.replaceFirst('public/storage/', '');
    } else if (cleanPath.startsWith('storage/')) {
      cleanPath = cleanPath.replaceFirst('storage/', '');
    } else if (cleanPath.contains('/storage/')) {
      // If storage is buried in the middle of a relative path, keep everything after it
      cleanPath = cleanPath.substring(cleanPath.indexOf('/storage/') + 9);
    }

    if (cleanPath.isEmpty || cleanPath == 'null') return '';

    final String finalBase = base.endsWith('/') ? base : '$base/';
    return '$finalBase$cleanPath';
  }

  static final RxMap<String, _ProductMeta> productCache =
      <String, _ProductMeta>{}.obs;

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString().trim();

    // 1. Resolve Product Data - Absolute Recursive Search
    final dynamic rawP =
        json['product'] ??
        json['ad'] ??
        json['item'] ??
        json['product_details'] ??
        json['ad_details'] ??
        json['product_info'] ??
        json['item_details'] ??
        json['order']?['product'] ??
        json['order']?['ad'] ??
        json['item_info'] ??
        json['ad_info'] ??
        json['conversation']?['product'] ??
        json['conversation']?['ad'] ??
        json['conversation']?['item'] ??
        json['conversation']?['product_details'] ??
        json['conversation']?['ad_details'] ??
        json['conversation']?['product_info'] ??
        json['conversation']?['item_details'] ??
        json['ad_details']?['ad'] ??
        json['product_details']?['product'];

    Map<String, dynamic> pMap = {};
    if (rawP is Map) {
      pMap = Map<String, dynamic>.from(rawP);
    } else if (rawP is String && rawP.isNotEmpty && rawP != 'null') {
      try {
        pMap = Map<String, dynamic>.from(jsonDecode(rawP));
      } catch (_) {}
    }

    // 2. Resolve Product ID (The Absolute Anchor)
    String pId =
        (json['product_id'] ??
                json['ad_id'] ??
                json['item_id'] ??
                json['order_id'] ??
                json['conversation']?['product_id'] ??
                json['conversation']?['ad_id'] ??
                json['conversation']?['item_id'] ??
                json['conversation']?['product']?['id'] ??
                json['conversation']?['ad']?['id'] ??
                json['product']?['id'] ??
                json['ad']?['id'] ??
                json['item']?['id'] ??
                json['ad_details']?['id'] ??
                json['product_details']?['id'] ??
                pMap['id'] ??
                pMap['product_id'] ??
                pMap['ad_id'] ??
                pMap['item_id'] ??
                '')
            .toString()
            .trim();

    final productId = (pId == 'null' || pId == '0') ? '' : pId;

    // 3. Resolve Seller ID
    final sId =
        (pMap['seller_id'] ??
                pMap['user_id'] ??
                pMap['created_by'] ??
                json['seller_id'] ??
                json['ad_seller_id'] ??
                json['conversation']?['seller_id'] ??
                json['conversation']?['product']?['seller_id'] ??
                '')
            .toString();

    // 4. Resolve Identity (STRICT: Product Only)
    String title =
        (pMap['name_en'] ??
                pMap['name_ar'] ??
                pMap['name_fr'] ??
                pMap['name'] ??
                pMap['title'] ??
                pMap['ad_title'] ??
                pMap['item_name'] ??
                pMap['product_name'] ??
                json['product_name'] ??
                json['item_name'] ??
                json['ad_title'] ??
                json['title'] ??
                '')
            .toString();

    // --- Hyper-Aggressive Image Search ---
    String avatar = '';

    final rawImg =
        (pMap['image_path'] ??
            pMap['main_image'] ??
            pMap['thumbnail'] ??
            pMap['cover_image'] ??
            pMap['product_image'] ??
            pMap['image'] ??
            pMap['ad_image'] ??
            pMap['item_image'] ??
            pMap['photo'] ??
            pMap['img'] ??
            pMap['picture'] ??
            pMap['product_image_path'] ??
            pMap['ad_image_path'] ??
            pMap['product_image_url'] ??
            json['product_image'] ??
            json['ad_image'] ??
            json['item_image_path'] ??
            json['product_image_path'] ??
            json['ad_image_path'] ??
            json['image_path'] ??
            json['main_image'] ??
            json['ad_details']?['main_image'] ??
            json['product_details']?['main_image'] ??
            json['conversation']?['product_image'] ??
            json['conversation']?['ad_image'] ??
            json['conversation']?['image'] ??
            json['conversation']?['product']?['main_image'] ??
            json['conversation']?['ad']?['main_image'] ??
            json['order']?['image_path'] ??
            json['order']?['product_image'] ??
            '');

    if (rawImg != null &&
        rawImg.toString().isNotEmpty &&
        rawImg.toString() != 'null') {
      avatar = rawImg.toString();
    }

    if (avatar.isEmpty || avatar == 'null') {
      final media =
          pMap['media'] ??
          pMap['product_media'] ??
          pMap['images'] ??
          json['images'] ??
          json['product_media'];

      if (media is List && media.isNotEmpty) {
        for (var item in media) {
          if (item is Map) {
            final url =
                (item['file_url'] ??
                        item['url'] ??
                        item['image'] ??
                        item['original_url'] ??
                        item['file_path'] ??
                        '')
                    .toString();
            if (url.isNotEmpty && url != 'null') {
              avatar = url;
              break;
            }
          } else if (item is String && item.isNotEmpty && item != 'null') {
            avatar = item;
            break;
          }
        }
      }
    }

    // 5. Cache Sync
    if (productId.isNotEmpty && productId != 'null') {
      final existingMeta = productCache[productId];
      String finalName = title;
      if (finalName.isEmpty || finalName == 'null') {
        finalName = existingMeta?.name ?? title;
      }
      String finalImg = ChatThread.normalizeAvatarPath(avatar);
      if (finalImg.isEmpty || !finalImg.startsWith('http')) {
        finalImg = existingMeta?.image ?? '';
      }
      if (finalName.isNotEmpty && finalName != 'null') {
        productCache[productId] = _ProductMeta(
          name: finalName,
          image: finalImg,
          sellerId: sId.isNotEmpty ? sId : (existingMeta?.sellerId ?? ''),
        );
        title = finalName;
        if (finalImg.startsWith('http')) avatar = finalImg;
      }
    }

    if (title.isEmpty || title == 'null') {
      title = productId.isNotEmpty ? 'Product #$productId' : 'Chat';
    }

    String finalAvatar = ChatThread.normalizeAvatarPath(avatar);

    if (productId.isNotEmpty && productId != 'null') {
      final cached = productCache[productId];
      if (cached != null) {
        if (title.isEmpty || title == 'null' || title.startsWith('Product #')) {
          if (cached.name.isNotEmpty && !cached.name.startsWith('Product #')) {
            title = cached.name;
          }
        }
        if (finalAvatar.isEmpty ||
            finalAvatar.contains('Rounded%20rectangle') ||
            !finalAvatar.startsWith('http')) {
          if (cached.image.isNotEmpty && cached.image.startsWith('http')) {
            finalAvatar = cached.image;
          }
        }
      }
    }

    final otherUser = json['other_user'] ?? {};
    final otherUserId = (otherUser['id'] ?? '').toString();
    final lastMsg = (json['last_message'] ?? json['message'] ?? '').toString();
    final lastTime =
        (json['last_message_time'] ?? json['time'] ?? json['created_at'] ?? '')
            .toString();
    final unread = int.tryParse((json['unread_count'] ?? '0').toString()) ?? 0;

    return ChatThread(
      id: id,
      title: title,
      lastMessage: lastMsg,
      timeLabel: lastTime,
      avatarPath: finalAvatar,
      otherUserId: otherUserId,
      productId: productId,
      productSellerId:
          (sId.isEmpty || sId == 'null')
              ? (productCache[productId]?.sellerId ?? '')
              : sId,
      unreadCount: unread,
    );
  }
}

class _ProductMeta {
  final String name;
  final String image;
  final String sellerId;
  _ProductMeta({
    required this.name,
    required this.image,
    required this.sellerId,
  });
}

class ChatMessage {
  final String id;
  final String? text;
  final String? imagePath;
  final String? invoicePath;
  final InvoiceData? invoiceData;
  final String timeLabel;
  final bool isMe;
  final String type; // 'text', 'image', 'invoice'

  ChatMessage({
    required this.id,
    this.text,
    this.imagePath,
    this.invoicePath,
    this.invoiceData,
    required this.timeLabel,
    required this.isMe,
    required this.type,
  });

  factory ChatMessage.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final id = (json['id'] ?? '').toString();
    // Use is_sender if available (from Postman extra trace)
    final bool isMe = json['is_sender'] ?? false;
    // API uses message_type or type
    final type = json['message_type'] ?? json['type'] ?? 'text';
    final msg = json['message'] ?? json['attachment_url'] ?? '';
    final time = json['created_at'] ?? '';

    InvoiceData? invoice;
    if (type == 'invoice' && json['invoice_data'] != null) {
      final invoiceJson = json['invoice_data'];
      final orderId =
          (invoiceJson?['order_id'] ??
                  json['order_id'] ??
                  json['item_id'] ??
                  '')
              .toString();

      invoice = InvoiceData(
        price: invoiceJson['price']?.toString() ?? '',
        quantity: invoiceJson['quantity']?.toString() ?? '',
        transportCost: invoiceJson['transportCost']?.toString() ?? '',
        delivery: invoiceJson['delivery']?.toString() ?? '',
        orderId: orderId.isNotEmpty ? orderId : null,
      );
    }

    return ChatMessage(
      id: id,
      text: (type == 'text' || type == 'location') ? msg : null,
      imagePath: type == 'image' ? msg : null,
      invoicePath: type == 'invoice' ? msg : null,
      invoiceData: invoice,
      timeLabel: time,
      isMe: isMe,
      type: type,
    );
  }
}

class ChatController extends GetxController {
  final RxList<ChatThread> threads = <ChatThread>[].obs;
  final RxBool isFetchingThreads = false.obs;

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isFetchingMessages = false.obs;
  final RxBool isSendingMessage = false.obs;

  final RxInt page = 1.obs;
  final RxBool hasMore = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt unreadCount = 0.obs;

  // Message Pagination State
  final RxInt messagePage = 1.obs;
  final RxBool hasMoreMessages = true.obs;
  final RxBool isLoadingMoreMessages = false.obs;

  final RxString currentUserId = ''.obs;
  final RxString currentOpenedConversationId = ''.obs;
  final Set<String> _manuallyReadIds = {};
  final Set<String> _activePusherSubscriptions = {};

  // Pusher real-time updates
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  // CACHE: List of product IDs owned by current user
  final RxSet<String> _myProductIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint('🚀 [ChatController] Starting Initialization...');
      await _initPusher();

      // Sequence: ID -> Read IDs -> My Products -> Threads
      await _loadCurrentUserId();
      await _loadReadIds();

      // Parallelize remaining non-critical startup tasks
      await Future.wait([_loadMyProducts(), fetchThreads()]);

      debugPrint('✅ [ChatController] Initialization Complete.');
    } catch (e) {
      debugPrint('❌ [ChatController] Initialization Error: $e');
    }
  }

  Future<void> _initPusher() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      await pusher.init(
        apiKey: PusherConstants.key,
        cluster: PusherConstants.cluster,
        authEndpoint: PusherConstants.host,
        authParams: {
          'headers': {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        },
        onEvent: _onPusherEvent,
        onSubscriptionSucceeded: (channelName, data) {
          debugPrint("✅ Subscribed to Pusher channel: $channelName");
        },
        onSubscriptionError: (message, error) {
          debugPrint("❌ Pusher subscription error: $message");
        },
        onError: (message, code, error) {
          debugPrint("❌ Pusher error: $message (Code: $code)");
        },
      );
      await pusher.connect();
    } catch (e) {
      debugPrint("❌ Error initializing Pusher: $e");
    }
  }

  void _onPusherEvent(PusherEvent event) {
    debugPrint(
      "🔔 Pusher Event Received: ${event.eventName} on ${event.channelName}",
    );

    try {
      final data = jsonDecode(event.data);
      // Sometimes Laravel events wrap data in 'message' or similar
      final msgJson = data['message'] ?? data['data'] ?? data;

      if (msgJson != null && msgJson is Map) {
        final newMessage = ChatMessage.fromJson(
          Map<String, dynamic>.from(msgJson),
          currentUserId.value,
        );

        final String convId =
            (msgJson['conversation_id'] ??
                    msgJson['id'] ??
                    event.channelName.split('.').last)
                .toString()
                .trim();

        // 1. If currently viewing this chat, add message instantly
        if (currentOpenedConversationId.value == convId) {
          if (!messages.any((m) => m.id == newMessage.id)) {
            messages.add(newMessage);
            messages.refresh();
            // Since we are viewing it, ensure count is cleared
            _clearLocalUnread(convId);
          }
        } else {
          // 2. Not in current chat? Update unread count for the thread
          final idx = threads.indexWhere((t) => t.id == convId);
          if (idx >= 0) {
            final t = threads[idx];
            // Only update if it's not a message FROM me (which shouldn't happen via Pusher usually, but possible)
            if (!newMessage.isMe) {
              // Remove from manually read set because a NEW message arrived
              if (_manuallyReadIds.contains(convId)) {
                _manuallyReadIds.remove(convId);
                _saveReadIds();
              }

              threads[idx] = t.copyWith(
                unreadCount: t.unreadCount + 1,
                lastMessage:
                    newMessage.type == 'text'
                        ? (newMessage.text ?? 'Media')
                        : newMessage.type,
                timeLabel: newMessage.timeLabel,
              );
              threads.refresh();
            } else {
              // It's my message, just update last message text without unread count
              threads[idx] = t.copyWith(
                lastMessage:
                    newMessage.type == 'text'
                        ? (newMessage.text ?? 'Media')
                        : newMessage.type,
                timeLabel: newMessage.timeLabel,
              );
              threads.refresh();
            }
          } else {
            // 3. New thread received! We don't have it in our list.
            // Since we can't construct a full thread from just a message, we must fetch fresh threads.
            fetchThreads();
          }
        }
      }
    } catch (e) {
      debugPrint("⚠️ Pusher processing error: $e");
    }

    // Recalculate global unread count for the navigation badge
    int total = 0;
    for (var t in threads) {
      total += t.unreadCount;
    }
    unreadCount.value = total;
  }

  Future<void> _subscribeToChat(String conversationId) async {
    if (conversationId.isEmpty) return;
    // Use private channel prefix as we now have auth
    final channelName = "private-chat.$conversationId";
    if (_activePusherSubscriptions.contains(channelName)) return;

    try {
      await pusher.subscribe(channelName: channelName);
      _activePusherSubscriptions.add(channelName);
      debugPrint("✅ Subscribed to Pusher channel: $channelName");
    } catch (e) {
      debugPrint("⚠️ Error subscribing to channel: $e");
    }
  }

  Future<void> _unsubscribeFromChat(String conversationId) async {
    if (conversationId.isEmpty) return;
    final channelName = "private-chat.$conversationId";
    try {
      await pusher.unsubscribe(channelName: channelName);
      _activePusherSubscriptions.remove(channelName);
      debugPrint("📤 Unsubscribed from Pusher channel: $channelName");
    } catch (e) {
      debugPrint("⚠️ Error unsubscribing from channel: $e");
    }
  }

  void leaveChat() {
    if (currentOpenedConversationId.value.isNotEmpty) {
      _unsubscribeFromChat(currentOpenedConversationId.value);
      currentOpenedConversationId.value = '';
    }
  }

  Future<void> _loadReadIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Load from generic key (always)
      final List<String>? genericIds = prefs.getStringList(
        'read_conversation_ids',
      );
      if (genericIds != null) {
        _manuallyReadIds.addAll(genericIds.map((e) => e.trim()));
      }

      // 2. Load from user-specific key if available
      final String userId = currentUserId.value.trim();
      if (userId.isNotEmpty && userId != 'null') {
        final String key = 'read_conversation_ids_$userId';
        final List<String>? userIds = prefs.getStringList(key);
        if (userIds != null) {
          _manuallyReadIds.addAll(userIds.map((e) => e.trim()));
        }
      }

      debugPrint('📩 Loaded ${_manuallyReadIds.length} read chat IDs');
    } catch (e) {
      debugPrint('❌ Error loading read IDs: $e');
    }
  }

  Future<void> _saveReadIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listToSave = _manuallyReadIds.map((e) => e.trim()).toList();

      // Always save to generic key for robustness
      await prefs.setStringList('read_conversation_ids', listToSave);

      // Also save to user-specific key for persistence across logout/login
      final String userId = currentUserId.value.trim();
      if (userId.isNotEmpty && userId != 'null') {
        final String key = 'read_conversation_ids_$userId';
        await prefs.setStringList(key, listToSave);
      }
    } catch (e) {
      debugPrint('❌ Error saving read IDs: $e');
    }
  }

  Future<void> _loadCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('user_id');
      if (id == null || id.isEmpty) {
        final apiService = Get.find<ApiService>();
        final response = await apiService.getProfile();
        if (response != null && response['status'] == true) {
          id = response['data']?['user']?['id']?.toString();
          if (id != null) {
            await prefs.setString('user_id', id);
          }
        }
      }
      currentUserId.value = id ?? '';
      debugPrint('👤 Current User ID: ${currentUserId.value}');
    } catch (e) {
      debugPrint('❌ Error loading current user ID: $e');
    }
  }

  Future<void> _loadMyProducts() async {
    try {
      final apiService = Get.find<ApiService>();
      // Fetch multiple types in parallel to ensure complete ownership list (Active, Sold, Inactive)
      final responses = await Future.wait([
        apiService.getMyAds(type: 1, limit: 100),
        apiService.getMyAds(type: 2, limit: 100),
        apiService.getMyAds(type: 3, limit: 100),
      ]);

      for (var response in responses) {
        if (response != null && response['status'] == true) {
          final dynamic data = response['data'];
          List products = [];
          if (data is Map) {
            if (data.containsKey('products') && data['products'] is List) {
              products = data['products'];
            } else if (data.containsKey('ads')) {
              final ads = data['ads'];
              if (ads is Map &&
                  ads.containsKey('data') &&
                  ads['data'] is List) {
                products = ads['data'];
              } else if (ads is List) {
                products = ads;
              }
            } else if (data.containsKey('data') && data['data'] is List) {
              products = data['data'];
            }
          } else if (data is List) {
            products = data;
          }

          for (var item in products) {
            if (item is Map) {
              final id = (item['id'] ?? '').toString();
              if (id.isNotEmpty) {
                _myProductIds.add(id);
                // Pre-populate cache with reliable product info
                ChatThread.productCache[id] = _ProductMeta(
                  name: (item['name_en'] ?? item['name'] ?? '').toString(),
                  image: ChatThread.normalizeAvatarPath(
                    (item['image_path'] ?? item['main_image'] ?? '').toString(),
                  ),
                  sellerId: currentUserId.value,
                );
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error loading my products for comprehensive check: $e');
    }
  }

  bool isSeller(String productSellerId, {String? productId}) {
    final String cId = currentUserId.value.toString().trim();
    if (cId.isEmpty) return false;

    final String sId = productSellerId.toString().trim();
    final String pId = (productId ?? '').toString().trim();

    // 1. Direct ID match
    if (sId.isNotEmpty && sId != 'null' && sId == cId) return true;

    // 2. Ownership Cache - Explicit from local Ads (Most Reliable)
    if (pId.isNotEmpty && pId != 'null' && _myProductIds.contains(pId)) {
      return true;
    }

    // 3. Static metadata lookup
    if (pId.isNotEmpty && pId != 'null') {
      final meta = ChatThread.productCache[pId];
      if (meta != null && meta.sellerId == cId) return true;
    }

    return false;
  }

  Future<void> fetchThreads({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMore.value || !hasMore.value) return;
        isLoadingMore.value = true;
      } else {
        // Defensive check: if currently building, defer state update
        if (WidgetsBinding.instance.schedulerPhase != SchedulerPhase.idle) {
          await Future.delayed(Duration.zero);
        }
        isFetchingThreads.value = true;
        page.value = 1;
        hasMore.value = true;
      }

      final apiService = Get.find<ApiService>();
      final response = await apiService.getAllConversations(page: page.value);
      if (response != null && response['status'] == true) {
        final List data = response['data'] ?? [];
        final List<ChatThread> remoteThreads =
            data.map((json) {
              final thread = ChatThread.fromJson(json);
              // Suppress unread count if manually read in this session
              if (_manuallyReadIds.contains(thread.id) ||
                  _manuallyReadIds.contains(thread.productId)) {
                return thread.copyWith(unreadCount: 0);
              }
              return thread;
            }).toList();

        // Keep local placeholders (e.g. from "Make a Deal") that aren't yet on server
        final localPlaceholders =
            threads
                .where(
                  (t) =>
                      t.id == t.productId &&
                      !remoteThreads.any((r) => r.productId == t.productId),
                )
                .toList();

        if (loadMore) {
          threads.addAll(remoteThreads);
        } else {
          final List<ChatThread> merged = [...remoteThreads];
          for (var local in localPlaceholders) {
            // Only insert local placeholder if no remote thread exists for this product
            final hasRemoteForProduct = remoteThreads.any(
              (r) => r.productId == local.productId,
            );
            if (!hasRemoteForProduct) {
              merged.insert(0, local);
            }
          }
          threads.value = merged;
        }

        hasMore.value = remoteThreads.length >= 20;
        if (remoteThreads.isNotEmpty) {
          page.value++;
        }

        // Update unread count based on processed threads (respects local suppression)
        _updateUnreadCountFromThreads();

        // Sync missing product images in background
        _syncMissingProductInfo(threads);

        // NEW: Subscribe to all threads for real-time updates
        _subscribeToAllThreads(threads);
      }
    } finally {
      isFetchingThreads.value = false;
      isLoadingMore.value = false;
    }
  }

  void _subscribeToAllThreads(List<ChatThread> threadsList) {
    for (var thread in threadsList) {
      if (thread.id.isNotEmpty && thread.id != 'null') {
        _subscribeToChat(thread.id);
      }
    }
  }

  // Set to keep track of products currently being fetched to avoid redundant calls
  final Set<String> _fetchingProductIds = {};

  void _syncMissingProductInfo(List<ChatThread> threadsList) {
    for (var thread in threadsList) {
      _syncThreadMetadata(thread);
    }
  }

  void _syncThreadMetadata(ChatThread thread) {
    if (thread.productId.isNotEmpty && thread.productId != 'null') {
      final hasValidImage =
          thread.avatarPath.isNotEmpty &&
          !thread.avatarPath.contains('Rounded%20rectangle') &&
          !thread.avatarPath.contains('person');

      if (!hasValidImage && !_fetchingProductIds.contains(thread.productId)) {
        _fetchProductDetailsInBackground(thread.productId);
      }
    }
  }

  Future<void> _fetchProductDetailsInBackground(String productId) async {
    if (productId.isEmpty || productId == 'null') return;
    _fetchingProductIds.add(productId);

    try {
      debugPrint(
        '🔍 [ChatController] Background sync for Product ID: $productId',
      );
      final apiService = Get.find<ApiService>();
      var response = await apiService.getAdDetails(productId);

      if (response == null || response['status'] != true) {
        debugPrint(
          '⚠️ [ChatController] getAdDetails failed, trying getProductDetails for ID: $productId',
        );
        response = await apiService.getProductDetails(productId);
      }

      if (response != null && response['status'] == true) {
        dynamic rawData =
            response['data']?['ad'] ??
            response['data']?['product'] ??
            response['data'];

        if (rawData is List && rawData.isNotEmpty) {
          rawData = rawData[0];
        }

        if (rawData is Map) {
          final id = (rawData['id'] ?? productId).toString();
          final name =
              (rawData['name_en'] ??
                      rawData['name_ar'] ??
                      rawData['name'] ??
                      rawData['title'] ??
                      '')
                  .toString();

          // Ultra-Aggressive Image Search in background sync
          String image = '';
          final media =
              rawData['media'] ??
              rawData['product_media'] ??
              rawData['images'] ??
              rawData['ad_media'] ??
              rawData['item_media'];
          if (media is List && media.isNotEmpty) {
            for (var m in media) {
              if (m is Map) {
                image =
                    (m['file_url'] ??
                            m['url'] ??
                            m['image'] ??
                            m['file_path'] ??
                            m['original_url'] ??
                            '')
                        .toString();
              } else if (m is String) {
                image = m;
              }
              if (image.isNotEmpty && image != 'null') break;
            }
          }
          if (image.isEmpty || image == 'null') {
            image =
                (rawData['image_path'] ??
                        rawData['main_image'] ??
                        rawData['product_image'] ??
                        rawData['image'] ??
                        rawData['thumbnail'] ??
                        rawData['photo'] ??
                        rawData['img'] ??
                        rawData['ad_image'] ??
                        rawData['item_image'] ??
                        rawData['product_image_path'] ??
                        rawData['ad_image_path'] ??
                        rawData['product_image_url'] ??
                        rawData['ad_details']?['main_image'] ??
                        rawData['product_details']?['main_image'] ??
                        '')
                    .toString();
          }

          final sellerId =
              (rawData['seller_id'] ?? rawData['user_id'] ?? '').toString();

          if (id.isNotEmpty && (name.isNotEmpty || image.isNotEmpty)) {
            final String normImg = ChatThread.normalizeAvatarPath(image);
            debugPrint(
              '✨ [ChatController] Found metadata for $id: Name="$name", Image="$normImg"',
            );

            ChatThread.productCache[id] = _ProductMeta(
              name:
                  name.isNotEmpty
                      ? name
                      : (ChatThread.productCache[id]?.name ?? 'Product #$id'),
              image:
                  normImg.startsWith('http')
                      ? normImg
                      : (ChatThread.productCache[id]?.image ?? normImg),
              sellerId:
                  sellerId.isNotEmpty
                      ? sellerId
                      : (ChatThread.productCache[id]?.sellerId ?? ''),
            );

            // CRITICAL: Update the actual thread objects in the reactive list
            bool changed = false;
            for (int i = 0; i < threads.length; i++) {
              if (threads[i].productId == id) {
                final String finalTitle =
                    name.isNotEmpty ? name : threads[i].title;
                // Only update if we actually got better data
                if (threads[i].avatarPath.isEmpty ||
                    (normImg.isNotEmpty &&
                        threads[i].avatarPath.contains(
                          'Rounded%20rectangle',
                        ))) {
                  threads[i] = threads[i].copyWith(
                    title: finalTitle,
                    avatarPath: normImg,
                  );
                  changed = true;
                }
              }
            }
            if (changed) {
              threads.refresh();
            }
          }
        }
      }
    } catch (e) {
      debugPrint(
        '⚠️ [ChatController] Background sync failed for $productId: $e',
      );
    } finally {
      // Small delay before allowing another fetch for this ID
      Future.delayed(const Duration(minutes: 5), () {
        _fetchingProductIds.remove(productId);
      });
    }
  }

  void _updateUnreadCountFromThreads() {
    int total = 0;
    for (var t in threads) {
      total += t.unreadCount;
    }
    unreadCount.value = total;
    debugPrint('📩 Total Unread Messages (Synced): ${unreadCount.value}');
  }

  void _clearLocalUnread(String conversationId) {
    bool changed = false;
    final String targetId = conversationId.trim();

    // 1. Find the thread to get the productId for comprehensive persistence
    String? linkedProductId;
    for (var t in threads) {
      if (t.id.trim() == targetId || t.productId.trim() == targetId) {
        linkedProductId = t.productId.trim();
        break;
      }
    }

    // 2. Add to persistent set and save immediately
    bool added = false;
    if (targetId.isNotEmpty && targetId != 'null') {
      if (!_manuallyReadIds.contains(targetId)) {
        _manuallyReadIds.add(targetId);
        added = true;
      }
    }

    if (linkedProductId != null &&
        linkedProductId.isNotEmpty &&
        linkedProductId != 'null' &&
        !_manuallyReadIds.contains(linkedProductId)) {
      _manuallyReadIds.add(linkedProductId);
      added = true;
    }

    if (added) {
      _saveReadIds();
    }

    // 3. Clear local counts for reactive UI feedback
    for (int i = 0; i < threads.length; i++) {
      if ((threads[i].id.trim() == targetId ||
              threads[i].productId.trim() == targetId ||
              (linkedProductId != null &&
                  threads[i].productId.trim() == linkedProductId)) &&
          threads[i].unreadCount > 0) {
        threads[i] = threads[i].copyWith(unreadCount: 0);
        changed = true;
      }
    }

    if (changed || added) {
      threads.refresh();
      // Recalculate global count
      int total = 0;
      for (var t in threads) {
        total += t.unreadCount;
      }
      unreadCount.value = total;
    }
  }

  Future<void> fetchMessages(
    String conversationId, {
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        if (isLoadingMoreMessages.value || !hasMoreMessages.value) return;
        isLoadingMoreMessages.value = true;
      } else {
        isFetchingMessages.value = true;
        messagePage.value = 1;
        hasMoreMessages.value = true;
        messages.clear(); // Only clear on fresh load
      }

      String targetId = conversationId;
      // If the provided ID is a placeholder (Product ID),
      // try to find if we already have a real conversation ID for this product
      final existingThread = threads.firstWhereOrNull(
        (t) =>
            (t.id == conversationId || t.productId == conversationId) &&
            t.otherUserId.isNotEmpty,
      );
      if (existingThread != null) {
        targetId = existingThread.id;
        if (!loadMore) {
          currentOpenedConversationId.value = targetId;
          _subscribeToChat(targetId);
          _syncThreadMetadata(existingThread);
          _clearLocalUnread(targetId);
        }
      } else {
        // If no thread, and conversationId is numeric, it's likely a productId. Sync it!
        if (conversationId.isNotEmpty &&
            conversationId != '0' &&
            conversationId != 'null') {
          _fetchProductDetailsInBackground(conversationId);
        }
      }

      final apiService = Get.find<ApiService>();
      final response = await apiService.getConversation(
        targetId,
        page: messagePage.value,
        limit: 20,
      );

      if (response != null && response['status'] == true) {
        final List data =
            (response['data'] is List)
                ? response['data']
                : (response['data']['messages'] ?? []);

        final newMessages =
            data
                .map((json) => ChatMessage.fromJson(json, currentUserId.value))
                .toList();

        // Check if there are more items to load
        if (newMessages.length < 20) {
          hasMoreMessages.value = false;
        } else {
          messagePage.value++;
        }

        if (loadMore) {
          // Add older messages to the START of the list (list is [Oldest → Newest])
          messages.insertAll(0, newMessages);
        } else {
          messages.assignAll(newMessages);

          // Ensure we are subscribed to this channel for live updates
          _subscribeToChat(targetId);

          // Sync thread info if available in response
          final dynamic metaConversation =
              (response['data'] is Map)
                  ? response['data']['conversation']
                  : null;
          if (metaConversation != null && metaConversation is Map) {
            try {
              final updatedThread = ChatThread.fromJson(
                Map<String, dynamic>.from(metaConversation),
              );
              final idx = threads.indexWhere(
                (t) =>
                    t.id == updatedThread.id ||
                    t.productId == updatedThread.productId,
              );
              if (idx >= 0) {
                // Smart Merge: Don't downgrade identity or message info
                var merged = updatedThread;

                // Preserve existing last message if new one is empty
                if (merged.lastMessage.isEmpty &&
                    threads[idx].lastMessage.isNotEmpty) {
                  merged = merged.copyWith(
                    lastMessage: threads[idx].lastMessage,
                    timeLabel: threads[idx].timeLabel,
                  );
                }

                // Absolute Truth: If we have messages, the last one is the REAL last message
                if (messages.isNotEmpty) {
                  final last =
                      messages.last; // Last item is newest in ASC order
                  final String lastText =
                      (last.type == 'text')
                          ? (last.text ?? '')
                          : (last.type == 'image' ? 'Image' : 'Document');

                  merged = merged.copyWith(
                    lastMessage: lastText,
                    timeLabel: last.timeLabel,
                  );
                }

                threads[idx] = merged;
                threads.refresh();
              }
            } catch (_) {}
          }
        }
      }
    } finally {
      isFetchingMessages.value = false;
      isLoadingMoreMessages.value = false;
    }
  }

  Future<Map<String, dynamic>?> generateInvoiceApi({
    required String buyerId,
    required String productId,
    required String price,
    required String quantity,
    required String transportCost,
    required String deliveryDuration,
  }) async {
    try {
      final apiService = Get.find<ApiService>();
      final formData = dio.FormData.fromMap({
        'buyer_id': buyerId,
        'product_id': productId,
        'price': price,
        'quantity': quantity,
        'transportation_cost': transportCost, // Correct Param
        'expected_delivery_days': deliveryDuration, // Correct Param
      });

      final response = await apiService.generateInvoice(formData);
      return response;
    } catch (e) {
      return null;
    }
  }

  void onChatScreenClosed() {
    leaveChat();
    // Defer fetch to next frame to avoid locked tree errors during dispose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchThreads();
    });
  }

  Future<bool> sendMessageApi(
    String conversationId,
    String message, {
    String type = 'text',
    String? filePath,
    String? productId,
    String? otherUserId,
  }) async {
    try {
      isSendingMessage.value = true;
      final apiService = Get.find<ApiService>();

      final Map<String, dynamic> data = {
        'message': message.toString(),
        'message_type': type.toString(),
        'type': type.toString(),
      };

      if (productId != null && productId.isNotEmpty) {
        data['product_id'] = productId.toString();
      }

      if (otherUserId != null && otherUserId.isNotEmpty) {
        data['other_user_id'] = otherUserId.toString();
      }

      // Send actual conversation ID or empty string for new conversations
      data['conversation_id'] =
          (conversationId.isNotEmpty && conversationId != productId)
              ? conversationId
              : '';

      if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          final fileSize = await file.length();
          debugPrint('📎 Attaching file: $filePath (${fileSize} bytes)');
          data['attachment'] = await dio.MultipartFile.fromFile(
            filePath,
            filename: 'Invoice.pdf',
          );
        } else {
          debugPrint('❌ File not found: $filePath');
        }
      }

      final response = await apiService.sendMessage(data);
      if (response != null && response['status'] == true) {
        final actualId =
            response['data']?['message']?['conversation_id']?.toString() ??
            conversationId;
        fetchMessages(actualId);
        fetchThreads();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> makeADeal(Product product) async {
    final String timeLabel = 'Just now';
    final String messageText = 'I am interested in ${product.name}';

    // 1. Optimistic UI: Create placeholder thread if it doesn't exist
    final id = product.id; // Using product ID as temp thread ID
    messages.clear();
    messages.add(
      ChatMessage(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        text: messageText,
        timeLabel: timeLabel,
        isMe: true,
        type: 'text',
      ),
    );

    // Call API to store message in backend
    await sendMessageApi(id, messageText, productId: product.id);

    final existingIndex = threads.indexWhere(
      (t) => t.id == id || t.productId == product.id,
    );
    if (existingIndex >= 0) {
      threads[existingIndex] = threads[existingIndex].copyWith(
        lastMessage: messageText,
        timeLabel: timeLabel,
      );
    } else {
      threads.insert(
        0,
        ChatThread(
          id: id,
          title: product.name,
          lastMessage: messageText,
          timeLabel: timeLabel,
          avatarPath: product.imagePath,
          otherUserId: '', // Placeholder until real thread
          productId: product.id,
          productSellerId: product.sellerId,
        ),
      );
    }
    threads.refresh();
  }

  // Helper for invoice download
  Future<String?> downloadInvoiceApi(dynamic orderId) async {
    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.downloadInvoice(orderId);

      if (response != null && response.containsKey('file_data')) {
        final data = response['file_data'];
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/invoice_$orderId.pdf');

        // Handle binary PDF data
        if (data is List<int>) {
          await file.writeAsBytes(data);
          debugPrint('✅ PDF saved to: ${file.path}');
          return file.path;
        } else if (data is String) {
          // Fallback: convert string to bytes
          final bytes = data.codeUnits;
          await file.writeAsBytes(bytes);
          debugPrint('✅ PDF saved to: ${file.path}');
          return file.path;
        }
      }

      // If it's a JSON response with a URL
      if (response != null && response['status'] == true) {
        return response['data']?['file_url'] ?? response['data']?['url'];
      }
    } catch (e) {
      debugPrint('❌ Error in downloadInvoiceApi: $e');
    }
    return null;
  }

  Future<void> deleteThread(String id) async {
    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.deleteConversation(id);
      if (response != null && response['status'] == true) {
        threads.removeWhere((t) => t.id == id);
        threads.refresh();
        Get.back();
        Get.snackbar(
          'Success',
          'Chat deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (_) {}
  }

  Future<void> sendOffer({
    required Product product,
    required String quantityKg,
  }) async {
    final id = product.id;
    final timeLabel = _formatTime(DateTime.now());
    final messageText = 'Offer: $quantityKg Kg of ${product.name}';

    // Call API to store message in backend
    await sendMessageApi(id, messageText, productId: product.id);

    final existingIndex = threads.indexWhere((t) => t.id == id);
    if (existingIndex >= 0) {
      threads[existingIndex] = threads[existingIndex].copyWith(
        lastMessage: messageText,
        timeLabel: timeLabel,
      );
    } else {
      threads.insert(
        0,
        ChatThread(
          id: id,
          title: product.name,
          lastMessage: messageText,
          timeLabel: timeLabel,
          avatarPath: product.imagePath,
          otherUserId: '', // Placeholder until real thread
          productId: product.id,
          productSellerId: product.sellerId,
        ),
      );
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  Future<bool> reportChatApi(String conversationId, String reason) async {
    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.reportChat(conversationId, reason);
      if (response != null && response['status'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error reporting chat: $e');
      return false;
    }
  }
}
