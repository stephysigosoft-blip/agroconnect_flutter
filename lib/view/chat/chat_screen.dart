import 'package:collection/collection.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../utils/invoice_pdf_helper.dart';
import '../orders/order_summary_screen.dart';
import '../sell/location_selection_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final ChatController _chatController;
  final ScrollController _scrollController = ScrollController();
  Worker? _scrollWorker;

  ChatThread? thread;
  InvoiceData? _pendingInvoice;
  final ImagePicker _picker = ImagePicker();
  bool _isReported = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_isReported) return;
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        _chatController.sendMessageApi(
          thread!.id,
          image.path,
          type: 'image',
          filePath: image.path,
          productId: thread!.productId,
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ChatController>()) {
      _chatController = Get.find<ChatController>();
    } else {
      _chatController = Get.put(ChatController());
    }

    if (!Get.isRegistered<OrdersController>()) {
      Get.put(OrdersController());
    }

    final args = Get.arguments;
    if (args is ChatThread) {
      thread = args;
      // Fetch messages after build to avoid blocking initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _chatController.fetchMessages(thread!.id);
      });
    } else {
      // Fallback: If no thread exists, we can't show this screen.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Get.back();
      });
    }

    // Auto-scroll to bottom on new messages
    _scrollWorker = ever(_chatController.messages, (_) {
      if (_scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  Widget _buildInvoiceBubble(ChatMessage msg) {
    final data = msg.invoiceData;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.waitingForBuyer,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l10n.autoCancelIn('48:00:35'),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xfff7f7f7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.orderSummary,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (data != null) ...[
                  _summaryRow(l10n.price, '${data.price} MRU'),
                  _summaryRow(l10n.quantity, '${data.quantity} Kg'),
                  _summaryRow(l10n.transport, '${data.transportCost} MRU'),
                  _summaryRow(l10n.delivery, '${data.delivery} days'),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.pdf,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Try to get orderId from invoiceData first, then fallback to msg.id
                    final String? orderIdStr = msg.invoiceData?.orderId;
                    if (orderIdStr != null && orderIdStr.isNotEmpty) {
                      final url = await _chatController.downloadInvoiceApi(
                        orderIdStr,
                      );
                      if (url != null && url.isNotEmpty) {
                        final uri = Uri.tryParse(url);
                        if (uri != null) {
                          try {
                            // ignore: deprecated_member_use
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            debugPrint('Error launching invoice URL: $e');
                          }
                        }
                      } else {
                        Get.snackbar(
                          l10n.error,
                          l10n.couldNotDownloadInvoice,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  child: Text(
                    '${l10n.invoice}.pdf',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _scrollWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (thread == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 2.0),
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFF1B834F),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        title: Obx(() {
          // Trigger rebuild when threads update (product cache populated)
          // ignore: unused_local_variable
          final _ = _chatController.threads.length;
          final String pId = thread!.productId;
          final cached = ChatThread.productCache[pId];

          final String currentTitle =
              (cached?.name ?? '').isNotEmpty ? cached!.name : thread!.title;

          final String cachedImage = cached?.image ?? '';
          final String currentAvatar =
              cachedImage.isNotEmpty ? cachedImage : thread!.avatarPath;

          return Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    currentAvatar.isNotEmpty && currentAvatar.startsWith('http')
                        ? Image.network(
                          currentAvatar,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 32,
                                height: 32,
                                color: Colors.grey.shade100,
                                child: const Icon(
                                  Icons.inventory_2,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : Container(
                          width: 32,
                          height: 32,
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.inventory_2,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              final l10n = AppLocalizations.of(context)!;
              return [
                PopupMenuItem<String>(
                  value: 'report',
                  child: Text(l10n.reportChat),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_chatController.isFetchingMessages.value &&
                  _chatController.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final displayMessages = _chatController.messages;
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: displayMessages.length,
                itemBuilder: (context, index) {
                  final msg = displayMessages[index];
                  return _buildMessageBubbleNew(msg);
                },
              );
            }),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubbleNew(ChatMessage msg) {
    final bubbleColor =
        msg.isMe ? const Color(0xFFD4E8D9) : const Color(0xFFE8EEF2);

    final alignment = msg.isMe ? Alignment.centerRight : Alignment.centerLeft;

    final crossAlign =
        msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isMe) ...[
              Obx(() {
                // Trigger rebuild when threads update
                // ignore: unused_local_variable
                final _ = _chatController.threads.length;
                final String pId = thread!.productId;
                final cachedImage = ChatThread.productCache[pId]?.image ?? '';
                final String avatarUrl =
                    cachedImage.isNotEmpty ? cachedImage : thread!.avatarPath;

                return Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 15),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child:
                          avatarUrl.isNotEmpty && avatarUrl.startsWith('http')
                              ? Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (c, e, s) => Container(
                                      color: Colors.grey.shade100,
                                      child: const Icon(
                                        Icons.inventory_2,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                              : Container(
                                color: Colors.grey.shade100,
                                child: const Icon(
                                  Icons.inventory_2,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                  ),
                );
              }),
            ],
            Column(
              crossAxisAlignment: crossAlign,
              children: [
                if (msg.type == 'text')
                  if (msg.text?.startsWith('INVOICE_PDF|') ?? false)
                    _buildPdfBubble(msg)
                  else if (msg.text?.startsWith('LOCATION|') ?? false)
                    _buildLocationBubble(msg)
                  else
                    Container(
                      constraints: const BoxConstraints(maxWidth: 240),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(msg.isMe ? 12 : 0),
                          bottomRight: Radius.circular(msg.isMe ? 0 : 12),
                        ),
                      ),
                      child: Text(
                        msg.text ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                else if (msg.type == 'image')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        msg.imagePath!.startsWith('http')
                            ? Image.network(
                              msg.imagePath!,
                              width: 220,
                              height: 130,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                            )
                            : Image.asset(
                              msg.imagePath!,
                              width: 220,
                              height: 130,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                            ),
                  )
                else if (msg.type == 'invoice')
                  _buildInvoiceBubble(msg),
                if (msg.timeLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                    child: Text(
                      msg.timeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Obx(() {
            if (thread == null) return const SizedBox.shrink();

            final activeThread =
                _chatController.threads.firstWhereOrNull(
                  (t) => t.id == thread?.id || t.productId == thread?.productId,
                ) ??
                thread!;

            final hasInvoice = _chatController.messages.any((m) {
              final text = m.text ?? '';
              return m.type == 'invoice' ||
                  text.toUpperCase().contains('INVOICE_PDF|');
            });

            final bool isSeller = _chatController.isSeller(
              activeThread.productSellerId,
              productId: activeThread.productId,
            );

            // 1. If I am the BUYER and an invoice exists, show Action Buttons
            if (!isSeller && hasInvoice) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Color(0xFF1B834F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(
                            color: Color(0xFF1B834F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final invoiceMsg =
                              _chatController.messages.reversed
                                  .firstWhereOrNull(
                                    (m) => m.type == 'invoice',
                                  ) ??
                              _chatController.messages.reversed
                                  .firstWhereOrNull((m) {
                                    final text = m.text ?? '';
                                    return text.toUpperCase().contains(
                                      'INVOICE_PDF|',
                                    );
                                  });

                          if (invoiceMsg != null) {
                            if (invoiceMsg.type == 'invoice' &&
                                invoiceMsg.invoiceData != null) {
                              final data = invoiceMsg.invoiceData!;
                              double total = 0;
                              try {
                                total =
                                    (double.parse(data.price) *
                                        double.parse(data.quantity)) +
                                    double.parse(data.transportCost);
                              } catch (_) {
                                total = 0;
                              }

                              final String activePId = activeThread.productId;
                              final cachedImg =
                                  ChatThread.productCache[activePId]?.image ??
                                  '';
                              final actualProductImage =
                                  cachedImg.isNotEmpty
                                      ? cachedImg
                                      : activeThread.avatarPath;

                              final invoice = InvoiceRecord(
                                id: data.orderId ?? activeThread.id,
                                productName: activeThread.title,
                                productImagePath: actualProductImage,
                                unitPrice: data.price,
                                quantity: data.quantity,
                                totalAmount: total.toStringAsFixed(2),
                                buyerName: '',
                                invoiceDate: DateTime.now().toString(),
                                statusLabel: 'Pending Payment',
                                statusColor: const Color(0xFFD4A017),
                                isCompleted: false,
                                pdfPath: '',
                              );
                              Get.to(
                                () => OrderSummaryScreen(invoice: invoice),
                              );
                            } else {
                              // Extract order ID from special text format
                              final text = invoiceMsg.text ?? '';
                              final parts = text.split('|');
                              final orderId =
                                  parts.length > 1 ? parts[1].trim() : '';

                              if (orderId.isNotEmpty) {
                                // Try to find in orders controller list first
                                final ordersController =
                                    Get.isRegistered<OrdersController>()
                                        ? Get.find<OrdersController>()
                                        : Get.put(OrdersController());
                                final existing = ordersController.boughtOrders
                                    .firstWhereOrNull((o) => o.id == orderId);

                                if (existing != null) {
                                  Get.to(
                                    () => OrderSummaryScreen(invoice: existing),
                                  );
                                } else {
                                  // Fallback: Try to find price info from any previous structured msg
                                  final structured = _chatController
                                      .messages
                                      .reversed
                                      .firstWhereOrNull(
                                        (m) =>
                                            m.type == 'invoice' &&
                                            m.invoiceData != null,
                                      );

                                  final String activePId =
                                      activeThread.productId;
                                  final cachedImg =
                                      ChatThread
                                          .productCache[activePId]
                                          ?.image ??
                                      '';
                                  final actualProductImage =
                                      cachedImg.isNotEmpty
                                          ? cachedImg
                                          : activeThread.avatarPath;

                                  final invoice = InvoiceRecord(
                                    id: orderId,
                                    productName: activeThread.title,
                                    productImagePath: actualProductImage,
                                    unitPrice:
                                        structured?.invoiceData?.price ?? '0',
                                    quantity:
                                        structured?.invoiceData?.quantity ??
                                        '0',
                                    totalAmount:
                                        structured != null
                                            ? (double.parse(
                                                      structured
                                                          .invoiceData!
                                                          .price,
                                                    ) *
                                                    double.parse(
                                                      structured
                                                          .invoiceData!
                                                          .quantity,
                                                    ))
                                                .toStringAsFixed(2)
                                            : '0',
                                    buyerName: '',
                                    invoiceDate: DateTime.now().toString(),
                                    statusLabel: 'Pending Payment',
                                    statusColor: const Color(0xFFD4A017),
                                    isCompleted: false,
                                    pdfPath: '',
                                  );
                                  // Async refresh
                                  ordersController.fetchBoughtOrders();
                                  Get.to(
                                    () => OrderSummaryScreen(invoice: invoice),
                                  );
                                }
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          minimumSize: const Size.fromHeight(48),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.payNow,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // 2. If I am the SELLER, show Generate Invoice
            if (isSeller) {
              return GestureDetector(
                onTap: _showGenerateInvoiceForm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B834F),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.generateInvoice,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            // ... if buyer and no invoice, show nothing
            return const SizedBox.shrink();
          }),
          // const SizedBox(height: 8),
          Container(
            color: const Color(0xFFF2F2F2),
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12,
              top: 12,
            ),
            child:
                _isReported
                    ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.chatReportedMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1B834F),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed:
                                        () => _pickImage(ImageSource.camera),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      hintText: l10n.messageHint,
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Color(0xFF1B834F),
                                    size: 24,
                                  ),
                                  onPressed: _handleSendMessage,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          offset: const Offset(0, -110),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'gallery') {
                              _pickImage(ImageSource.gallery);
                            } else if (value == 'location') {
                              _sendLocation();
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'gallery',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.image,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      l10n.gallery,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'location',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      l10n.sendLocation,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF1B834F).withOpacity(0.5),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  void _handleSendMessage() {
    if (_isReported) return;
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _chatController.sendMessageApi(
      thread!.id,
      text,
      productId: thread!.productId,
    );
    _messageController.clear();
  }

  void _showReportDialog() {
    final TextEditingController reasonController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              l10n.reportChat,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reason),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: l10n.pleaseEnterReason,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B834F)),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final reason = reasonController.text.trim();
                  if (reason.isEmpty) {
                    Get.snackbar(
                      l10n.error,
                      l10n.pleaseEnterReason,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Navigator.pop(context); // Close dialog

                  // Show loading indicator or simple feedback?
                  // User requested simple "call api".

                  final success = await _chatController.reportChatApi(
                    thread!.id,
                    reason,
                  );

                  if (success) {
                    if (mounted) {
                      setState(() {
                        _isReported = true;
                      });
                      Get.snackbar(
                        l10n.success,
                        l10n.adReported, // Using generic reported success message
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF1B834F),
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    if (mounted) {
                      Get.snackbar(
                        l10n.error,
                        l10n.failedReport,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B834F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.submit, // Using "Submit" as Report button label
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showPaymentRules() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            l10n.paymentRules,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1, height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRuleBullet(
                              'Invoice will be cancelled automatically if the buyer does not confirm within 48 hours.',
                            ),
                            _buildRuleBullet(
                              'Dispute must be raised within 72 hours.',
                            ),
                            _buildRuleBullet(
                              'Cras dapibus est suscipit accumsan sollicitudin.',
                            ),
                            _buildRuleBullet(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            ),
                            _buildRuleBullet(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            ),
                            _buildRuleBullet(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                      side: const BorderSide(
                                        color: Color(0xFF1B834F),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.cancel,
                                      style: const TextStyle(
                                        color: Color(0xFF1B834F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final invoice = _pendingInvoice;
                                      if (invoice == null) {
                                        if (context.mounted)
                                          Navigator.pop(context);
                                        return;
                                      }

                                      final response = await _chatController
                                          .generateInvoiceApi(
                                            buyerId: thread!.otherUserId,
                                            productId: thread!.productId,
                                            price: invoice.price,
                                            quantity: invoice.quantity,
                                            transportCost:
                                                invoice.transportCost,
                                            deliveryDuration: invoice.delivery,
                                          );

                                      if (response != null &&
                                          response['status'] == true) {
                                        // Get the newly generated invoice ID (order_id)
                                        final orderId = response['data']?['id'];

                                        if (orderId != null) {
                                          // Send invoice message with special format
                                          // Format: INVOICE_PDF|order_id|filename
                                          // This allows the UI to recognize and display it as a PDF
                                          await _chatController.sendMessageApi(
                                            thread!.id,
                                            'INVOICE_PDF|$orderId|Invoice.pdf',
                                            type: 'text',
                                            productId: thread!.productId,
                                          );
                                        }

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                        _pendingInvoice =
                                            null; // Clear after success
                                        _chatController.fetchMessages(
                                          thread!.id,
                                        );
                                      } else {
                                        Get.snackbar(
                                          l10n.error,
                                          l10n.failedToGenerateInvoice,
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1B834F),
                                      minimumSize: const Size.fromHeight(48),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.generateInvoice,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black, size: 28),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRuleBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  void _showGenerateInvoiceForm() {
    final l10n = AppLocalizations.of(context)!;
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    final transportController = TextEditingController();
    final deliveryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            l10n.generateInvoice,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1, height: 1),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 24,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 16,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.enterPrice,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(priceController),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.enterQuantity,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(quantityController),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.enterTransportCost,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(transportController),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.selectExpectedDelivery,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(
                                  deliveryController,
                                  suffix: Container(
                                    width: 80,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4E8D9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      l10n.days,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(
                                            48,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFF1B834F),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          l10n.cancel,
                                          style: const TextStyle(
                                            color: Color(0xFF1B834F),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (priceController.text
                                              .trim()
                                              .isEmpty) {
                                            Get.snackbar(
                                              l10n.required,
                                              l10n.pleaseEnterPrice,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }
                                          if (double.tryParse(
                                                priceController.text.trim(),
                                              ) ==
                                              null) {
                                            Get.snackbar(
                                              l10n.invalidInput,
                                              l10n.validNumericPrice,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }

                                          if (quantityController.text
                                              .trim()
                                              .isEmpty) {
                                            Get.snackbar(
                                              l10n.required,
                                              l10n.pleaseEnterQuantity,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }
                                          if (double.tryParse(
                                                quantityController.text.trim(),
                                              ) ==
                                              null) {
                                            Get.snackbar(
                                              l10n.invalidInput,
                                              l10n.validNumericQuantity,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }

                                          if (transportController.text
                                              .trim()
                                              .isEmpty) {
                                            Get.snackbar(
                                              l10n.required,
                                              l10n.pleaseEnterTransportCost,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }
                                          if (double.tryParse(
                                                transportController.text.trim(),
                                              ) ==
                                              null) {
                                            Get.snackbar(
                                              l10n.invalidInput,
                                              l10n.validNumericTransport,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }

                                          if (deliveryController.text
                                              .trim()
                                              .isEmpty) {
                                            Get.snackbar(
                                              l10n.required,
                                              l10n.pleaseEnterDeliveryDuration,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }
                                          if (int.tryParse(
                                                deliveryController.text.trim(),
                                              ) ==
                                              null) {
                                            Get.snackbar(
                                              l10n.invalidInput,
                                              l10n.validNumericDays,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.redAccent,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }

                                          _pendingInvoice = InvoiceData(
                                            price: priceController.text.trim(),
                                            quantity:
                                                quantityController.text.trim(),
                                            transportCost:
                                                transportController.text.trim(),
                                            delivery:
                                                deliveryController.text.trim(),
                                          );
                                          Navigator.pop(context);
                                          _showPaymentRules();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1B834F,
                                          ),
                                          minimumSize: const Size.fromHeight(
                                            48,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          l10n.proceed,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black, size: 28),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilledField(TextEditingController controller, {Widget? suffix}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff2f2f2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1B834F), width: 1),
        ),
      ),
    );
  }

  Widget _buildLocationBubble(ChatMessage msg) {
    final rawText = msg.text ?? '';
    final locationData =
        rawText.startsWith('LOCATION|') ? rawText.substring(9) : rawText;
    final parts = locationData.split(',');
    String mapUrl = "";
    if (parts.length == 2) {
      final lat = parts[0].trim();
      final long = parts[1].trim();
      // Using Yandex Static Maps API as a reliable free option for coordinates
      mapUrl =
          "https://static-maps.yandex.ru/1.x/?ll=$long,$lat&z=13&l=map&size=400,200&pt=$long,$lat,pm2rdl";
    }

    return GestureDetector(
      onTap: () async {
        if (parts.length == 2) {
          final lat = parts[0].trim();
          final long = parts[1].trim();
          final url =
              'https://www.google.com/maps/search/?api=1&query=$lat,$long';
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        width: 220,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          image:
              mapUrl.isNotEmpty
                  ? DecorationImage(
                    image: NetworkImage(mapUrl),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 238, 21, 6),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'View Location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPdfBubble(ChatMessage msg) {
    // Parse the invoice format: INVOICE_PDF|order_id|filename
    final parts = msg.text?.split('|') ?? [];
    final orderId = parts.length > 1 ? parts[1] : '';
    final filename = parts.length > 2 ? parts[2] : 'Invoice.pdf';

    return GestureDetector(
      onTap: () {
        if (orderId.isNotEmpty) {
          final ordersController = Get.find<OrdersController>();
          ordersController.viewInvoice(null, orderId: orderId);
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                filename,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendLocation() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.sendLocation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.my_location, color: Colors.blue),
                  title: const Text('Current Location'),
                  onTap: () async {
                    Get.back();
                    await _sendCurrentLocation();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map, color: Color(0xFF1B834F)),
                  title: const Text('Select Location'),
                  onTap: () async {
                    Get.back();
                    final result = await Get.to(
                      () => const LocationSelectionScreen(),
                    );
                    if (result != null && result is Map) {
                      final lat = result['latitude'];
                      final long = result['longitude'];
                      final String locationStr = '$lat,$long';
                      _chatController.sendMessageApi(
                        thread!.id,
                        'LOCATION|$locationStr',
                        type: 'text',
                        productId: thread!.productId,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _sendCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your settings.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are denied.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permissions are permanently denied, we cannot request permissions.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      final String locationStr = '${position.latitude},${position.longitude}';
      _chatController.sendMessageApi(
        thread!.id,
        'LOCATION|$locationStr',
        type: 'text',
        productId: thread!.productId,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      Get.snackbar(
        'Error',
        'Failed to get current location',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
