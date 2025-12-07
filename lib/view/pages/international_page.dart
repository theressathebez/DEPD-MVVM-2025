part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  late HomeViewModel vm;

  final weightController = TextEditingController();
  final searchCountryController = TextEditingController();

  String selectedCourier = "tiki";
  final courierList = ["jne", "pos", "tiki", "dhl"];

  String? selectedCountryCode;
  String? selectedCountryName;

  Province? selectedProvince;
  City? selectedCity;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<HomeViewModel>(context, listen: false);

    if (vm.provinceList.status == Status.notStarted) {
      vm.getProvinceList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// ========================= COURIER & WEIGHT =========================
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCourier,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: courierList
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedCourier = v!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Berat (gr)',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ========================= ORIGIN INDONESIA =========================
            const Text(
              "Origin (Indonesia)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// PROVINCE DROPDOWN
            Consumer<HomeViewModel>(
              builder: (context, vm, _) {
                if (vm.provinceList.status == Status.loading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }

                final provinces = vm.provinceList.data ?? [];

                return DropdownButtonFormField<Province>(
                  value: vm.selectedProvinceId == null
                      ? null
                      : vm.provinceList.data?.firstWhere(
                          (p) => p.id == vm.selectedProvinceId,
                          orElse: () => vm.provinceList.data!.first,
                        ),
                  hint: const Text('Pilih provinsi'),
                  items:
                      vm.provinceList.data?.map((prov) {
                        return DropdownMenuItem(
                          value: prov,
                          child: Text(prov.name ?? ""),
                        );
                      }).toList() ??
                      [],
                  onChanged: (prov) {
                    if (prov != null) {
                      vm.setSelectedProvince(prov.name!, prov.id!);
                      vm.getCityOriginList(prov.id!);
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            /// CITY DROPDOWN
            Consumer<HomeViewModel>(
              builder: (context, vm, _) {
                if (vm.cityOriginList.status == Status.notStarted) {
                  return const Text(
                    "Pilih provinsi dulu",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  );
                }

                if (vm.cityOriginList.status == Status.loading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }

                final cities = vm.cityOriginList.data ?? [];

                return DropdownButtonFormField<City>(
                  value: selectedCity,
                  hint: const Text("Pilih kota"),
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city.name ?? ""),
                    );
                  }).toList(),
                  onChanged: (city) {
                    setState(() {
                      selectedCity = city;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            /// ========================= DESTINATION COUNTRY =========================
            const Text(
              "Destination (International)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: searchCountryController,
              decoration: InputDecoration(
                hintText: "Cari negara (min 3 karakter)",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (searchCountryController.text.length >= 3) {
                      vm.searchCountry(searchCountryController.text);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// COUNTRY RESULT LIST
            Consumer<HomeViewModel>(
              builder: (context, vm, _) {
                if (vm.countryList.status == Status.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                final countries = vm.countryList.data ?? [];

                if (countries.isEmpty) {
                  return const Text("Tidak ada negara ditemukan.");
                }

                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];

                      final isSelected =
                          selectedCountryName == country.countryName;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            country.countryName ?? "-",
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedCountryName = country.countryName;
                              selectedCountryCode = country.countryId;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Dipilih: ${country.countryName}",
                                ),
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// ========================= SUBMIT BUTTON =========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCity == null ||
                      selectedCountryCode == null ||
                      weightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lengkapi semua field!"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final weight = int.tryParse(weightController.text) ?? 0;
                  if (weight <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Berat harus lebih dari 0"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  vm.checkInternationalCost(
                    selectedCity!.id.toString(),
                    selectedCountryCode.toString(),
                    weight,
                    selectedCourier,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  "Hitung Ongkir Internasional",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ========================= RESULT =========================
            Consumer<HomeViewModel>(
              builder: (context, vm, _) {
                if (vm.intCostList.status == Status.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                if (vm.intCostList.status == Status.error) {
                  return Text(
                    vm.intCostList.message ?? "Error",
                    style: const TextStyle(color: Colors.red),
                  );
                }

                if (vm.intCostList.status == Status.completed) {
                  final data = vm.intCostList.data ?? [];

                  if (data.isEmpty) {
                    return const Text("Tidak ada data ongkir internasional.");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final cost = data[index];

                      return GestureDetector(
                        onTap: () => _showInterCostDetail(context, cost),
                        child: CardInterCost(cost)
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _showInterCostDetail(BuildContext context, InterCost cost) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= HEADER (Ikon Pesawat + Judul) =================
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flight_takeoff,
                            color: Colors.blue,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cost.name ?? "-",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              cost.code ?? "-",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ======================== DETAIL ITEMS ========================
                    _interDetailRow("Biaya", "Rp${cost.cost ?? 0}"),
                    const SizedBox(height: 6),

                    _interDetailRow("Estimasi", cost.etd?.toString() ?? "-"),
                    const SizedBox(height: 6),

                    _interDetailRow("Layanan", cost.service ?? "-"),
                    const SizedBox(height: 6),

                    _interDetailRow("Deskripsi", cost.description ?? "-"),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _interDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        const Text(" : "),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    ),
  );
}
