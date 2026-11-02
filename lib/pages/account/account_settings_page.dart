import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/auth_service.dart';
import '../landing_page.dart';

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
}) =>
    GoogleFonts.plusJakartaSans(
        fontSize: size, fontWeight: weight, color: color, height: height);

// ── Account Settings Page ─────────────────────────────────────────────────────
class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _orderUpdates = true;
  bool _promoAlerts = true;
  bool _activityAlerts = false;
  bool _biometric = true;

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
        title: Text('Account Settings',
            style: _pjs(size: 17, weight: FontWeight.w800)),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _buildAccountShield(),
          const SizedBox(height: 12),
          _buildProfileSection(),
          const SizedBox(height: 12),
          _buildDeliveryAddresses(),
          const SizedBox(height: 12),
          _buildAccountSecurity(),
          const SizedBox(height: 12),
          _buildNotifications(),
          const SizedBox(height: 12),
          _buildHelpSupport(),
          const SizedBox(height: 20),
          _buildSaveButton(),
          const SizedBox(height: 20),
          _buildAccountActions(),
        ],
      ),
    );
  }

  // ── Account Shield ──────────────────────────────────────────────────────────
  Widget _buildAccountShield() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _kChip,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: _kSecondary.withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: Icon(Icons.shield_outlined, size: 20, color: _kSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Account Shield: High',
                        style: _pjs(
                            size: 13, weight: FontWeight.w700, color: _kGreen)),
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: _kGreen, shape: BoxShape.circle),
                    ),
                  ],
                ),
                Text('3FA active & verified contact channels',
                    style: _pjs(size: 11, color: _kSubtext)),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: _kGreen, size: 20),
        ],
      ),
    );
  }

  // ── Profile ─────────────────────────────────────────────────────────────────
  Widget _buildProfileSection() {
    return SettingsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: _kChip,
                  child: Icon(Icons.person, size: 46, color: _kPrimary),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _kSecondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Full name
          _ProfileRow(
            label: 'FULL NAME',
            value: 'Jane Doe',
            actionIcon: Icons.edit_outlined,
            onAction: () => _pushEdit(context, 'Full Name', 'Jane Doe'),
          ),
          const Divider(color: _kBorder, height: 16),
          // Email
          _ProfileRow(
            label: 'EMAIL ADDRESS',
            value: 'jane.doe@example.com',
            badge: 'Verified',
            badgeColor: _kGreen,
            actionLabel: 'Edit',
            onAction: () =>
                _pushEdit(context, 'Email Address', 'jane.doe@example.com'),
            sub: 'Triggers OTP verification',
          ),
          const Divider(color: _kBorder, height: 16),
          // Mobile
          _ProfileRow(
            label: 'MOBILE NUMBER',
            value: '+63 917 123 4567',
            badge: 'Verified',
            badgeColor: _kGreen,
            actionLabel: 'Edit',
            onAction: () =>
                _pushEdit(context, 'Mobile Number', '+63 917 123 4567'),
            sub: 'Triggers OTP verification',
          ),
        ],
      ),
    );
  }

  // ── Delivery Addresses ──────────────────────────────────────────────────────
  Widget _buildDeliveryAddresses() {
    return SettingsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 18, color: _kSecondary),
                  const SizedBox(width: 6),
                  Text('Delivery Addresses',
                      style: _pjs(size: 15, weight: FontWeight.w800)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: _kChip, borderRadius: BorderRadius.circular(9999)),
                child: Text('2 Saved',
                    style: _pjs(
                        size: 11, weight: FontWeight.w700, color: _kSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _AddressCard(
            tag: 'Home',
            isDefault: true,
            name: 'Jane Doe • +63 917 123 4567',
            address:
                '123 Mabini St., Brgy. Central, Quezon City, Metro Manila, 1100',
          ),
          const SizedBox(height: 8),
          _AddressCard(
            tag: 'Work / Office',
            name: 'Jane Doe • +63 917 123 4567',
            address: '4th Floor, One Cyberzone, Ortigas Ave, Pasig City, 1605',
            isDefault: false,
            canSetDefault: true,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: Text('Add New Address',
                style:
                    _pjs(size: 13, weight: FontWeight.w700, color: _kPrimary)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _kPrimary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }

  // ── Account Security ────────────────────────────────────────────────────────
  Widget _buildAccountSecurity() {
    return SettingsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, size: 18, color: _kSecondary),
              const SizedBox(width: 6),
              Text('Account Security',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          _SecurityRow(
            icon: Icons.lock_reset_outlined,
            title: 'Change Password',
            sub: 'Last updated 3 months ago',
            onTap: () => _pushPasswordChange(context),
          ),
          const Divider(color: _kBorder, height: 12),
          _SecurityRow(
            icon: Icons.fingerprint,
            title: 'Biometric Sign-In',
            sub: 'Use Face ID / Touch ID for checkout',
            trailing: Switch(
              value: _biometric,
              onChanged: (v) => setState(() => _biometric = v),
              activeThumbColor: _kPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Notifications ───────────────────────────────────────────────────────────
  Widget _buildNotifications() {
    return SettingsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 18, color: _kSecondary),
              const SizedBox(width: 6),
              Text('Notifications Preferences',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          _NotifRow(
            title: 'Order Updates',
            sub: 'Track orders, pickup pins & delivery arrival',
            value: _orderUpdates,
            onChanged: (v) => setState(() => _orderUpdates = v),
          ),
          const Divider(color: _kBorder, height: 12),
          _NotifRow(
            title: 'Promo & Voucher Alerts',
            sub: 'Flash sales, personalised drops, voucher expiry',
            value: _promoAlerts,
            onChanged: (v) => setState(() => _promoAlerts = v),
          ),
          const Divider(color: _kBorder, height: 12),
          _NotifRow(
            title: 'Account Activity',
            sub: 'Unrecognised logins, bonus, alerts, coin balance',
            value: _activityAlerts,
            onChanged: (v) => setState(() => _activityAlerts = v),
          ),
        ],
      ),
    );
  }

  // ── Help & Support ──────────────────────────────────────────────────────────
  Widget _buildHelpSupport() {
    return SettingsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, size: 18, color: _kSecondary),
              const SizedBox(width: 6),
              Text('Help & Support',
                  style: _pjs(size: 15, weight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.quiz_outlined,
            title: 'Frequently Asked Questions (FAQs)',
            onTap: () {},
          ),
          const Divider(color: _kBorder, height: 1),
          _SettingsTile(
            icon: Icons.support_agent_outlined,
            title: 'Contact Customer Support',
            sub: 'Available 24/7 via chat',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Save Button ─────────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Changes saved!',
                  style: _pjs(
                      size: 13, color: Colors.white, weight: FontWeight.w600)),
              backgroundColor: _kPrimary,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.save_outlined, size: 18, color: Colors.white),
        label: Text('Save Changes',
            style:
                _pjs(size: 15, weight: FontWeight.w700, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimary,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
    );
  }

  // ── Account Actions ─────────────────────────────────────────────────────────
  Widget _buildAccountActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ACCOUNT MAINTENANCE',
              style: _pjs(size: 10, weight: FontWeight.w700, color: _kSubtext)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder),
            ),
            child: Column(
              children: [
                // Log Out
                ListTile(
                  leading: Icon(Icons.logout_outlined, color: _kText, size: 20),
                  title: Text('Log Out',
                      style: _pjs(size: 14, weight: FontWeight.w600)),
                  trailing: Icon(Icons.chevron_right, color: _kSubtext),
                  onTap: () => _confirmLogout(context),
                ),
                const Divider(height: 1, color: _kBorder, indent: 16),
                // Deactivate
                ListTile(
                  leading: Icon(Icons.pause_circle_outline,
                      color: _kSubtext, size: 20),
                  title: Text('Deactivate Account',
                      style: _pjs(
                          size: 14, weight: FontWeight.w600, color: _kSubtext)),
                  trailing: Icon(Icons.chevron_right, color: _kSubtext),
                  onTap: () => _confirmDeactivate(context),
                ),
                const Divider(height: 1, color: _kBorder, indent: 16),
                // Delete
                ListTile(
                  leading: Icon(Icons.delete_outline, color: _kFlash, size: 20),
                  title: Row(
                    children: [
                      Text('Delete Account',
                          style: _pjs(
                              size: 14,
                              weight: FontWeight.w600,
                              color: _kFlash)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _kFlash.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Pinned',
                            style: _pjs(
                                size: 9,
                                weight: FontWeight.w700,
                                color: _kFlash)),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Permanently erases orders, mimoo coins balance, chats, and review history. This action cannot be undone.',
                    style: _pjs(size: 10, color: _kSubtext, height: 1.4),
                  ),
                  trailing: Icon(Icons.chevron_right, color: _kSubtext),
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────────
  void _confirmLogout(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out', style: _pjs(size: 18, weight: FontWeight.w800)),
        content: Text('Are you sure you want to log out?',
            style: _pjs(size: 14, color: _kSubtext)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: _pjs(size: 14, color: _kSubtext)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // close the dialog first
              await AuthService.instance.logout();
              if (ctx.mounted) {
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LandingPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
            ),
            child: Text('Log Out',
                style: _pjs(
                    size: 14, weight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeactivate(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Deactivate Account',
            style: _pjs(size: 17, weight: FontWeight.w800)),
        content: Text(
          'Your account will be hidden. You can reactivate it any time by logging back in.',
          style: _pjs(size: 14, color: _kSubtext, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: _pjs(size: 14, color: _kSubtext)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kSubtext,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
            ),
            child: Text('Deactivate',
                style: _pjs(
                    size: 14, weight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.warning_amber_rounded, color: _kFlash, size: 48),
        title: Text('Delete Account',
            style: _pjs(size: 17, weight: FontWeight.w800, color: _kFlash)),
        content: Text(
          'This will permanently erase all your data including orders, coins, chats, and review history. This action cannot be undone.',
          style: _pjs(size: 13, color: _kSubtext, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: _pjs(size: 14, color: _kSubtext)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kFlash,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
            ),
            child: Text('Delete Permanently',
                style: _pjs(
                    size: 14, weight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _pushEdit(BuildContext ctx, String field, String current) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => _EditFieldPage(field: field, current: current),
      ),
    );
  }

  void _pushPasswordChange(BuildContext ctx) {
    Navigator.push(
        ctx, MaterialPageRoute(builder: (_) => const _ChangePasswordPage()));
  }
}

// ── Reusable Section Card ─────────────────────────────────────────────────────
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: child,
    );
  }
}

// ── Profile row ───────────────────────────────────────────────────────────────
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.label,
    required this.value,
    this.badge,
    this.badgeColor,
    this.actionIcon,
    this.actionLabel,
    this.sub,
    this.onAction,
  });
  final String label, value;
  final String? badge, actionLabel, sub;
  final Color? badgeColor;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: _pjs(size: 9, weight: FontWeight.w700, color: _kSubtext)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child:
                  Text(value, style: _pjs(size: 14, weight: FontWeight.w600)),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? _kGreen).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(badge!,
                    style: _pjs(
                        size: 10,
                        weight: FontWeight.w700,
                        color: badgeColor ?? _kGreen)),
              ),
            if (actionIcon != null)
              GestureDetector(
                onTap: onAction,
                child: Icon(actionIcon, size: 18, color: _kSecondary),
              ),
            if (actionLabel != null)
              GestureDetector(
                onTap: onAction,
                child: Text(actionLabel!,
                    style: _pjs(
                        size: 13, weight: FontWeight.w700, color: _kSecondary)),
              ),
          ],
        ),
        if (sub != null) ...[
          const SizedBox(height: 2),
          Text(sub!, style: _pjs(size: 10, color: _kSubtext)),
        ],
      ],
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.tag,
    required this.name,
    required this.address,
    this.isDefault = false,
    this.canSetDefault = false,
  });
  final String tag, name, address;
  final bool isDefault, canSetDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDefault ? _kSecondary : _kBorder,
            width: isDefault ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isDefault ? _kChip : _kSurface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _kBorder),
                ),
                child: Text(tag,
                    style: _pjs(
                        size: 11,
                        weight: FontWeight.w700,
                        color: isDefault ? _kSecondary : _kText)),
              ),
              if (isDefault) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: _kGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('DEFAULT',
                      style: _pjs(
                          size: 9, weight: FontWeight.w800, color: _kGreen)),
                ),
              ],
              const Spacer(),
              Icon(Icons.edit_outlined, size: 16, color: _kSecondary),
              const SizedBox(width: 12),
              Icon(Icons.delete_outline, size: 16, color: _kFlash),
            ],
          ),
          const SizedBox(height: 6),
          Text(name, style: _pjs(size: 13, weight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(address, style: _pjs(size: 12, color: _kSubtext, height: 1.4)),
          if (canSetDefault) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: Text('Set as default shipping address',
                  style: _pjs(
                      size: 11, weight: FontWeight.w600, color: _kSecondary)),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Security row ──────────────────────────────────────────────────────────────
class _SecurityRow extends StatelessWidget {
  const _SecurityRow({
    required this.icon,
    required this.title,
    required this.sub,
    this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String title, sub;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: _kSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _pjs(size: 13, weight: FontWeight.w700)),
                Text(sub, style: _pjs(size: 11, color: _kSubtext)),
              ],
            ),
          ),
          trailing ??
              Icon(Icons.keyboard_arrow_down, size: 20, color: _kSubtext),
        ],
      ),
    );
  }
}

// ── Notification row ──────────────────────────────────────────────────────────
class _NotifRow extends StatelessWidget {
  const _NotifRow({
    required this.title,
    required this.sub,
    required this.value,
    required this.onChanged,
  });
  final String title, sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _pjs(size: 13, weight: FontWeight.w700)),
              Text(sub, style: _pjs(size: 11, color: _kSubtext, height: 1.4)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeThumbColor: _kPrimary),
      ],
    );
  }
}

// ── Settings tile ─────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.sub,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String? sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: _kSecondary),
      title: Text(title, style: _pjs(size: 13, weight: FontWeight.w700)),
      subtitle: sub != null
          ? Text(sub!, style: _pjs(size: 11, color: _kSubtext))
          : null,
      trailing: Icon(Icons.chevron_right, color: _kSubtext),
      onTap: onTap,
    );
  }
}

// ── Edit Field Page ───────────────────────────────────────────────────────────
class _EditFieldPage extends StatefulWidget {
  const _EditFieldPage({required this.field, required this.current});
  final String field, current;

  @override
  State<_EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<_EditFieldPage> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.current);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
        title: Text('Edit ${widget.field}',
            style: _pjs(size: 17, weight: FontWeight.w800)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _ctrl,
              style: _pjs(size: 14),
              decoration: InputDecoration(
                labelText: widget.field,
                labelStyle:
                    _pjs(size: 11, weight: FontWeight.w700, color: _kSubtext),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: _kCard,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kPrimary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 52),
              ),
              child: Text('Save',
                  style: _pjs(
                      size: 15, weight: FontWeight.w700, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Change Password Page ──────────────────────────────────────────────────────
class _ChangePasswordPage extends StatefulWidget {
  const _ChangePasswordPage();

  @override
  State<_ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<_ChangePasswordPage> {
  bool _obscure1 = true, _obscure2 = true, _obscure3 = true;
  final _formKey = GlobalKey<FormState>();

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
        title: Text('Change Password',
            style: _pjs(size: 17, weight: FontWeight.w800)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _PasswordField(
                label: 'Current Password',
                obscure: _obscure1,
                onToggle: () => setState(() => _obscure1 = !_obscure1),
              ),
              const SizedBox(height: 14),
              _PasswordField(
                label: 'New Password',
                obscure: _obscure2,
                onToggle: () => setState(() => _obscure2 = !_obscure2),
              ),
              const SizedBox(height: 14),
              _PasswordField(
                label: 'Confirm New Password',
                obscure: _obscure3,
                onToggle: () => setState(() => _obscure3 = !_obscure3),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password updated!',
                          style: _pjs(
                              size: 13,
                              color: Colors.white,
                              weight: FontWeight.w600)),
                      backgroundColor: _kPrimary,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text('Update Password',
                    style: _pjs(
                        size: 15,
                        weight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.obscure,
    required this.onToggle,
  });
  final String label;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      style: _pjs(size: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _pjs(size: 11, weight: FontWeight.w700, color: _kSubtext),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: _kCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 18,
            color: _kSubtext,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kPrimary, width: 1.5),
        ),
      ),
    );
  }
}
