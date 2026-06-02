import 'package:flutter/material.dart';

class AntenatalCareBanner extends StatelessWidget {
  const AntenatalCareBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue[900], // Matches standard DHIS2 brand colors
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Fixed syntax typo here
        children: [
          // Left Widget Side: Three Lines (Menu) + Extend Icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.menu, color: Colors.white, size: 22),
                onPressed: () {
                  // TODO: Implement Left Menu Actions
                },
              ),
              const SizedBox(width: 6),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.unfold_more, color: Colors.white70, size: 18),
                onPressed: () {
                  // TODO: Implement Left Extension Logic
                },
              ),
            ],
          ),

          // Center Texts Block
          const Expanded(
            child: Text(
              "Antenatal Care",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Right Widget Side: Clickable Dropdown Menu + Extend Icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: "Show Modules",
                onSelected: (String value) {
                  // Handle navigation logic based on the clicked menu option
                  switch (value) {
                    case 'malaria':
                      // Get.to(() => MalariaScreen()); // Example for your GetX routing
                      print("Navigate to Malaria Module");
                      break;
                    case 'immunization':
                      print("Navigate to Immunization Module");
                      break;
                    // Add more navigation cases here later
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'malaria',
                    child: Row(
                      children: [
                        Icon(Icons.bug_report, size: 20, color: Colors.black54),
                        SizedBox(width: 10),
                        Text('Malaria Data'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'immunization',
                    child: Row(
                      children: [
                        Icon(Icons.vaccines, size: 20, color: Colors.black54),
                        SizedBox(width: 10),
                        Text('Immunization Data'),
                      ],
                    ),
                  ),
                  // 💡 Add your next menu options here following the same structure
                ],
              ),
              const SizedBox(width: 6),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.open_in_full, color: Colors.white70, size: 16),
                onPressed: () {
                  // TODO: Implement Right Extension Logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}