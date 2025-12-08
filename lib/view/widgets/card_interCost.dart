part of 'widgets.dart';

class CardInterCost extends StatefulWidget {
  final InterCost cost;
  const CardInterCost (this.cost, {super.key});

  @override
  State<CardInterCost> createState() => _CardInterCostState();
}

class _CardInterCostState extends State<CardInterCost> {
  // Memformat angka menjadi mata uang Rupiah
  String rupiahMoneyFormatter(double? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  // Memformat satuan "day" menjadi "hari" pada estimasi pengiriman
  String formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return '-';
    return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
  }

  @override
  Widget build(BuildContext context) {
    InterCost cost = widget.cost;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue[800]!),
      ),
      margin: const EdgeInsetsDirectional.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      color: Colors.white,
      child: ListTile(
        title: Text(
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.w700,
          ),
          "${cost.name}: ${cost.service}",
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              "Biaya: ${rupiahMoneyFormatter(cost.cost)}",
            ),
            const SizedBox(height: 4),
            Text(
              style: TextStyle(color: Colors.grey[700]),
              "Estimasi: ${formatEtd(cost.etd)}",
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(Icons.flight, color: Colors.blue[800]),
        ),
      ),
    );
  }
}
