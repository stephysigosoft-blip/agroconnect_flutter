import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/chat_controller.dart';
import '../../utils/invoice_pdf_helper.dart';
import '../orders/orders_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final RxList<_ChatMessage> _messages = <_ChatMessage>[].obs;

  late final ChatThread thread;
  InvoiceData? _pendingInvoice;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Handle picked image (e.g., send it as a message or show preview)
        _messages.add(
          _ChatMessage(
            imagePath: image.path,
            timeLabel: TimeOfDay.now().format(context),
            isMe: true,
            type: ChatMessageType.image,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    thread = Get.arguments as ChatThread;

    // Seed with sample messages (to match design)
    _messages.addAll([
      _ChatMessage(
        text: 'Hi',
        timeLabel: '10:00 AM',
        isMe: true,
        type: ChatMessageType.text,
      ),
      _ChatMessage(
        text: 'Hi',
        timeLabel: '10:00 AM',
        isMe: false,
        type: ChatMessageType.text,
      ),
      _ChatMessage(
        text:
            'Etiam at vulputate dui. Ut venenatis nisi id vestibulum posuere. Vestibulum consectetur',
        timeLabel: '10:15 AM',
        isMe: true,
        type: ChatMessageType.text,
      ),
      _ChatMessage(
        imagePath: 'lib/assets/images/categories/Rounded rectangle.png',
        timeLabel: '',
        isMe: false,
        type: ChatMessageType.image,
      ),
    ]);
  }

  Widget _buildInvoiceBubble(_ChatMessage msg) {
    final data = msg.invoiceData;
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
              const Expanded(
                child: Text(
                  'Waiting for buyer confirmation',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Auto cancel in 48:00:35',
                style: TextStyle(
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
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                if (data != null) ...[
                  _summaryRow('Price', '${data.price} MRU'),
                  _summaryRow('Quantity', '${data.quantity} Kg'),
                  _summaryRow('Transport', '${data.transportCost} MRU'),
                  _summaryRow('Delivery', '${data.delivery} days'),
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
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Invoice.pdf',
                  style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                thread.avatarPath,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              thread.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    final bubbleColor =
        msg.isMe ? const Color(0xFFD4E8D9) : const Color(0xFFE8EEF2);

    final alignment = msg.isMe ? Alignment.centerRight : Alignment.centerLeft;

    final crossAlign =
        msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: crossAlign,
          children: [
            if (msg.type == ChatMessageType.text)
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  msg.text ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              )
            else if (msg.type == ChatMessageType.image)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  msg.imagePath!,
                  width: 220,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              )
            else if (msg.type == ChatMessageType.invoice)
              _buildInvoiceBubble(msg),
            if (msg.timeLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                child: Text(
                  msg.timeLabel,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Obx(() {
            final hasInvoice = _messages.any(
              (m) => m.type == ChatMessageType.invoice,
            );
            if (hasInvoice) {
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
                          // TODO: Implement cancel logic
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Color(0xFF1B834F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
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
                          // TODO: Implement pay now logic
                          Get.to(() => const OrdersScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          minimumSize: const Size.fromHeight(48),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(
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
                child: const Text(
                  'Generate Invoice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
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
            child: Row(
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
                            onPressed: () => _pickImage(ImageSource.camera),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Message....',
                              hintStyle: TextStyle(
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
                      // TODO: send location
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'gallery',
                        child: Row(
                          children: const [
                            Icon(Icons.image, color: Colors.black, size: 20),
                            SizedBox(width: 12),
                            Text('Gallery', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'location',
                        child: Row(
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Send Location',
                              style: TextStyle(fontSize: 14),
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
                    child: const Icon(Icons.add, color: Colors.black, size: 24),
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
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final time = TimeOfDay.now();
    final label =
        '${time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';

    _messages.add(
      _ChatMessage(
        text: text,
        timeLabel: label,
        isMe: true,
        type: ChatMessageType.text,
      ),
    );
    _messageController.clear();
  }

  void _showPaymentRules() {
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Payment Rules',
                            style: TextStyle(
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
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
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
                                      _pendingInvoice = null;

                                      final path =
                                          await InvoicePdfHelper.generateInvoice(
                                            invoice,
                                          );
                                      log(path);
                                      _messages.add(
                                        _ChatMessage(
                                          invoicePath: path,
                                          invoiceData: invoice,
                                          timeLabel: '',
                                          isMe: true,
                                          type: ChatMessageType.invoice,
                                        ),
                                      );
                                      final chatController =
                                          Get.find<ChatController>();
                                      chatController.addInvoiceRecord(
                                        thread: thread,
                                        data: invoice,
                                        pdfPath: path,
                                        isSold: true,
                                      );
                                      if (context.mounted) {
                                        Navigator.pop(context);
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
                                    child: const Text(
                                      'Generate Invoice',
                                      style: TextStyle(
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Generate Invoice',
                            style: TextStyle(
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
                                const Text(
                                  'Enter Price',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(priceController),
                                const SizedBox(height: 16),
                                const Text(
                                  'Enter Quantity',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(quantityController),
                                const SizedBox(height: 16),
                                const Text(
                                  'Enter Transport Cost',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildFilledField(transportController),
                                const SizedBox(height: 16),
                                const Text(
                                  'Select Expected Delivery',
                                  style: TextStyle(
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
                                    child: const Text(
                                      'Days',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
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
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
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
                                        child: const Text(
                                          'Proceed',
                                          style: TextStyle(
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
}

enum ChatMessageType { text, image, invoice }

class _ChatMessage {
  final String? text;
  final String? imagePath;
  final String? invoicePath;
  final InvoiceData? invoiceData;
  final String timeLabel;
  final bool isMe;
  final ChatMessageType type;

  _ChatMessage({
    this.text,
    this.imagePath,
    this.invoicePath,
    this.invoiceData,
    required this.timeLabel,
    required this.isMe,
    required this.type,
  });
}
