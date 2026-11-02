import 'package:flutter/material.dart';

// Sample Philippine address data (placeholder)
const Map<String, Map<String, List<String>>> _addressData = {
  'Metro Manila': {
    'Quezon City': [
      'Batasan Hills',
      'Commonwealth',
      'Cubao',
      'Diliman',
      'Fairview'
    ],
    'Manila': ['Binondo', 'Ermita', 'Intramuros', 'Malate', 'Paco'],
    'Makati': [
      'Bel-Air',
      'Forbes Park',
      'Poblacion',
      'Rockwell',
      'San Lorenzo'
    ],
    'Taguig': ['BGC', 'Calzada', 'Hagonoy', 'Ligid-Tipas', 'Lower Bicutan'],
    'Pasig': ['Kapitolyo', 'Oranbo', 'Pasig Centro', 'Rosario', 'San Joaquin'],
  },
  'Cebu': {
    'Cebu City': ['Apas', 'Banilad', 'Capitol Site', 'Labangon', 'Mabolo'],
    'Mandaue': ['Alang-Alang', 'Bakilid', 'Banilad', 'Basak', 'Cambaro'],
    'Lapu-Lapu': ['Agus', 'Babag', 'Bankal', 'Baring', 'Buaya'],
  },
  'Davao del Sur': {
    'Davao City': ['Agdao', 'Buhangin', 'Bunawan', 'Calinan', 'Toril'],
    'Digos': ['Aplaya', 'Dawis', 'Dulangan', 'Goma', 'Ruparan'],
  },
  'Laguna': {
    'San Pedro': ['Cuyab', 'Estrella', 'Fatima', 'Nueva', 'San Antonio'],
    'Calamba': ['Bagong Kalsada', 'Bucal', 'Canlubang', 'Halang', 'Parian'],
    'Santa Rosa': ['Aplaya', 'Balibago', 'Caingin', 'Dila', 'Ibaba'],
  },
  'Cavite': {
    'Bacoor': ['Alima', 'Aniban', 'Banalo', 'Bayanan', 'Campo Santo'],
    'Imus': ['Alapan', 'Anabu', 'Buhay na Tubig', 'Bucandala', 'Magdalo'],
    'Dasmariñas': [
      'Burol',
      'Emmanuel Bergado',
      'Langkaan',
      'Salawag',
      'Sampaloc'
    ],
  },
};

typedef AddressChangedCallback = void Function(
    String province, String municipality, String barangay);

class AddressDropdown extends StatefulWidget {
  const AddressDropdown({
    super.key,
    this.onChanged,
    this.initialProvince,
    this.initialMunicipality,
    this.initialBarangay,
  });

  final AddressChangedCallback? onChanged;
  final String? initialProvince;
  final String? initialMunicipality;
  final String? initialBarangay;

  @override
  State<AddressDropdown> createState() => _AddressDropdownState();
}

class _AddressDropdownState extends State<AddressDropdown> {
  String? _province;
  String? _municipality;
  String? _barangay;

  List<String> get _provinces => _addressData.keys.toList();

  List<String> get _municipalities =>
      _province != null ? _addressData[_province]!.keys.toList() : [];

  List<String> get _barangays => (_province != null && _municipality != null)
      ? _addressData[_province]![_municipality] ?? []
      : [];

  @override
  void initState() {
    super.initState();
    _province = widget.initialProvince;
    _municipality = widget.initialMunicipality;
    _barangay = widget.initialBarangay;
  }

  void _onProvinceChanged(String? value) {
    setState(() {
      _province = value;
      _municipality = null;
      _barangay = null;
    });
    _notifyChanged();
  }

  void _onMunicipalityChanged(String? value) {
    setState(() {
      _municipality = value;
      _barangay = null;
    });
    _notifyChanged();
  }

  void _onBarangayChanged(String? value) {
    setState(() => _barangay = value);
    _notifyChanged();
  }

  void _notifyChanged() {
    if (widget.onChanged != null &&
        _province != null &&
        _municipality != null &&
        _barangay != null) {
      widget.onChanged!(_province!, _municipality!, _barangay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _province,
          decoration: const InputDecoration(
            labelText: 'Province / Region *',
            border: OutlineInputBorder(),
          ),
          items: _provinces
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: _onProvinceChanged,
          validator: (v) => v == null ? 'Province is required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _municipality,
          decoration: const InputDecoration(
            labelText: 'Municipality / City *',
            border: OutlineInputBorder(),
          ),
          items: _municipalities
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: _municipality == null && _province == null
              ? null
              : _onMunicipalityChanged,
          validator: (v) => v == null ? 'Municipality is required' : null,
          disabledHint: Text(
            _province == null ? 'Select province first' : 'Select municipality',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _barangay,
          decoration: const InputDecoration(
            labelText: 'Barangay *',
            border: OutlineInputBorder(),
          ),
          items: _barangays
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: _barangays.isEmpty ? null : _onBarangayChanged,
          validator: (v) => v == null ? 'Barangay is required' : null,
          disabledHint: Text(
            _municipality == null
                ? 'Select municipality first'
                : 'Select barangay',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }
}
