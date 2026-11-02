import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../orders/orders_page.dart';

const _kPrimary = Color(0xFF34175B);
const _kSecondary = Color(0xFF6B38D4);
const _kFlash = Color(0xFFFF3B5C);
const _kSurface = Color(0xFFF5F4FC);
const _kCard = Color(0xFFFFFFFF);
const _kChip = Color(0xFFEFE9FD);
const _kBorder = Color(0xFFDDD8F0);
const _kText = Color(0xFF1A1035);
const _kSubtext = Color(0xFF8A84A3);
const _kGreen = Color(0xFF1DB966);

TextStyle _pjs({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = _kText,
  double? height,
  TextDecoration? decoration,
}) =>
    GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        decoration: decoration);

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _showDetails = true;
  int _selectedPayment = 1; // COD pre-selected (index 1)
  final _noteCtrl = TextEditingController();
  int _secondsLeft = 14 * 60 + 56;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _noteCtrl.dispose();
    super.dispose();
  }

  String get _countdownText {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      appBar: AppBar(
        backgroundColor: _kCard,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _kText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Instant Checkout',
            style: _pjs(size: 17, weight: FontWeight.w800, color: _kText)),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          _buildTopStrip(),
          const SizedBox(height: 10),
          _buildDeliveryAddress(),
          const SizedBox(height: 10),
          _buildPackageOverview(),
          const SizedBox(height: 10),
          _buildShippingMethod(),
          const SizedBox(height: 10),
          _buildPaymentMethod(),
          const SizedBox(height: 10),
          _buildOrderNotes(),
          const SizedBox(height: 10),
          _buildPaymentSummary(),
          const SizedBox(height: 10),
          _buildTrustRow(),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildTopStrip() {
    return Container(
      color: _kCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🛡️', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text('FAST & SECURE CHECKOUT',
                  style: _pjs(
                      size: 12, weight: FontWeight.w700, color: _kPrimary)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kFlash.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: _kFlash),
                const SizedBox(width: 4),
                Text(_countdownText,
                    style: _pjs(
                        size: 13, weight: FontWeight.w800, color: _kFlash)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return _SCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                const BoxDecoration(color: _kChip, shape: BoxShape.circle),
            child: Icon(Icons.location_on_outlined, size: 18, color: _kPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Jane Doe',
                        style: _pjs(size: 14, weight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Text('(+63) 917 123 4567',
                        style: _pjs(size: 12, color: _kSubtext)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                    '123 Mabini St., Brgy. Commonwealth, Quezon City, Metro Manila',
                    style: _pjs(size: 12, color: _kSubtext, height: 1.4)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: _kSubtext),
        ],
      ),
    );
  }

  Widget _buildPackageOverview() {
    return _SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Package Overview (2 Items)',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
              TextButton.icon(
                onPressed: () => setState(() => _showDetails = !_showDetails),
                icon: Icon(
                    _showDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: _kSecondary),
                label: Text(_showDetails ? 'Hide details' : 'Show details',
                    style: _pjs(
                        size: 12, weight: FontWeight.w600, color: _kSecondary)),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ],
          ),
          if (_showDetails) ...[
            const SizedBox(height: 12),
            _CheckoutItemRow(
              imageUrl: 'https://picsum.photos/seed/cardigan/200/200',
              name: 'Chic Knit Ribbed Crop Cardigan',
              variation: 'Color: Lilac Bloom | Size: M',
              price: 899,
              originalPrice: 1299,
              qty: 1,
            ),
            const Divider(height: 16, color: _kBorder),
            _CheckoutItemRow(
              imageUrl: 'https://picsum.photos/seed/skirt/200/200',
              name: 'Pleated Pastel A-Line Skirt',
              variation: 'Color: Soft Violet | Size: S',
              price: 590,
              originalPrice: 750,
              qty: 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingMethod() {
    return _SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Method',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
              Text('Guaranteed by Aug 28-29',
                  style:
                      _pjs(size: 12, color: _kGreen, weight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _kChip,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kSecondary.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 16, color: _kSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Standard Express Delivery',
                              style: _pjs(size: 13, weight: FontWeight.w700)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _kGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('FREE VOUCHER',
                                style: _pjs(
                                    size: 9,
                                    weight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                      Text('Estimated 2-3 Days Metro Manila',
                          style: _pjs(size: 11, color: _kSubtext)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₱0',
                        style: _pjs(
                            size: 14, weight: FontWeight.w800, color: _kGreen)),
                    Text('₱80',
                        style: _pjs(
                            size: 11,
                            color: _kSubtext,
                            decoration: TextDecoration.lineThrough)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    final methods = [
      (
        Icons.account_balance_wallet_outlined,
        const Color(0xFF0066CC),
        'GCash',
        '0917 ••••567',
        'Linked ✓'
      ),
      (
        Icons.money_outlined,
        _kGreen,
        'Cash on Delivery (COD)',
        'Pay in cash right upon receipt',
        null
      ),
    ];

    return _SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment Method',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kFlash.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Fast 1-Click Pay',
                    style: _pjs(
                        size: 11, weight: FontWeight.w700, color: _kFlash)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(methods.length, (i) {
            final m = methods[i];
            final sel = _selectedPayment == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedPayment = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sel ? _kChip : _kSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: sel ? _kSecondary : _kBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: m.$2.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(m.$1, size: 18, color: m.$2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.$3,
                              style: _pjs(size: 13, weight: FontWeight.w700)),
                          Text(m.$4, style: _pjs(size: 11, color: _kSubtext)),
                        ],
                      ),
                    ),
                    if (m.$5 != null)
                      Text(m.$5!,
                          style: _pjs(
                              size: 11,
                              weight: FontWeight.w600,
                              color: _kGreen)),
                    const SizedBox(width: 6),
                    Icon(
                      sel
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 18,
                      color: sel ? _kSecondary : _kSubtext,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderNotes() {
    return _SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Notes for Courier',
              style: _pjs(size: 15, weight: FontWeight.w800)),
          const SizedBox(height: 10),
          TextField(
            controller: _noteCtrl,
            minLines: 2,
            maxLines: 4,
            style: _pjs(size: 13),
            decoration: InputDecoration(
              hintText: 'e.g. Please ring the bell, leave at door...',
              hintStyle: _pjs(size: 12, color: _kSubtext),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBorder)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBorder)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return _SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment Summary',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Vouchers Applied',
                    style: _pjs(
                        size: 11, weight: FontWeight.w700, color: _kGreen)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SRow('Merchandise Subtotal', '₱1,489'),
          const SizedBox(height: 6),
          _SRow('Shipping Subtotal', '₱80'),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Discount',
                  style: _pjs(
                      size: 13, weight: FontWeight.w500, color: _kSecondary)),
              Text('-₱80',
                  style: _pjs(
                      size: 13, weight: FontWeight.w600, color: _kSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mimoo Welcome Voucher',
                  style: _pjs(
                      size: 13, weight: FontWeight.w500, color: _kSecondary)),
              Text('-₱150',
                  style: _pjs(
                      size: 13, weight: FontWeight.w600, color: _kSecondary)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: _kBorder),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Payment',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
              Text('₱1,339',
                  style:
                      _pjs(size: 20, weight: FontWeight.w800, color: _kFlash)),
            ],
          ),
          const SizedBox(height: 4),
          Text('VAT inclusive', style: _pjs(size: 11, color: _kSubtext)),
        ],
      ),
    );
  }

  Widget _buildTrustRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 14, color: _kSubtext),
          const SizedBox(width: 4),
          Text('Mimoo Buyer Guarantee · 256-Bit SSL Secured',
              style: _pjs(size: 11, color: _kSubtext)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: _kCard,
        boxShadow: [
          BoxShadow(
              color: Color(0x1A34175B), blurRadius: 12, offset: Offset(0, -4))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount', style: _pjs(size: 12, color: _kSubtext)),
                  Text('₱1,339',
                      style: _pjs(size: 20, weight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Color(0xFF1DB966), size: 52),
                  title: Text('Order Placed! 🎉',
                      style: _pjs(size: 18, weight: FontWeight.w800)),
                  content: Text(
                      'Your order has been placed. We\'ll notify you once it\'s on its way!',
                      style: _pjs(size: 14, color: _kSubtext),
                      textAlign: TextAlign.center),
                  actions: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Close dialog, then navigate to OrdersPage
                          // clearing cart and checkout from the stack
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const OrdersPage()),
                            (route) => route.isFirst,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Track My Order',
                            style: _pjs(
                                size: 14,
                                weight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.arrow_forward,
                  size: 16, color: Colors.white),
              label: Text('Place Order',
                  style: _pjs(
                      size: 15, weight: FontWeight.w700, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SCard extends StatelessWidget {
  const _SCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D34175B), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

class _CheckoutItemRow extends StatelessWidget {
  const _CheckoutItemRow({
    required this.imageUrl,
    required this.name,
    required this.variation,
    required this.price,
    required this.originalPrice,
    required this.qty,
  });

  final String imageUrl, name, variation;
  final double price, originalPrice;
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: _kChip,
                  child: Icon(Icons.image_outlined, color: _kSubtext))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: _pjs(size: 13, weight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              Text(variation, style: _pjs(size: 11, color: _kSubtext)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('₱${price.toStringAsFixed(0)}',
                      style: _pjs(
                          size: 14,
                          weight: FontWeight.w800,
                          color: _kSecondary)),
                  const SizedBox(width: 6),
                  Text('₱${originalPrice.toStringAsFixed(0)}',
                      style: _pjs(
                          size: 11,
                          color: _kSubtext,
                          decoration: TextDecoration.lineThrough)),
                ],
              ),
            ],
          ),
        ),
        Text('x$qty', style: _pjs(size: 13, weight: FontWeight.w600)),
      ],
    );
  }
}

class _SRow extends StatelessWidget {
  const _SRow(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _pjs(size: 13, weight: FontWeight.w500)),
        Text(value, style: _pjs(size: 13, weight: FontWeight.w600)),
      ],
    );
  }
}
