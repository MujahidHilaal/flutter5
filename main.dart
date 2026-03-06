import 'package:flutter/material.dart';

void main() {
  runApp(const KabaddiApp());
}

class KabaddiApp extends StatelessWidget {
  const KabaddiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlayerScreen(),
    );
  }
}

class Player {
  String name;
  String team;
  Player({required this.name, required this.team});
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<Player> players = [];

  // Controllers for input dialog
  TextEditingController playerController = TextEditingController();
  TextEditingController teamController = TextEditingController();

  // SnackBar helper
  void showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Add or Edit Player Dialog
  void showPlayerDialog({Player? player, int? index}) {
    if (player != null) {
      // Editing: prefill fields
      playerController.text = player.name.replaceAll(" 🤾‍♂️", "");
      teamController.text = player.team.replaceAll(" 🟢", "");
    } else {
      playerController.clear();
      teamController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(player == null ? "Add Kabaddi Player 🏆" : "Edit Player ✏️"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: playerController,
              decoration: const InputDecoration(
                labelText: "Player Name",
                hintText: "Enter player name",
              ),
            ),
            TextField(
              controller: teamController,
              decoration: const InputDecoration(
                labelText: "Team Name",
                hintText: "Enter team name",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showSnack("Cancelled ❌", Colors.orange);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (playerController.text.isNotEmpty &&
                  teamController.text.isNotEmpty) {
                setState(() {
                  if (player == null) {
                    // Add new player
                    players.add(Player(
                      name: playerController.text + " 🤾‍♂️",
                      team: teamController.text + " 🟢",
                    ));
                    showSnack("Player Added 🎉", Colors.green);
                  } else {
                    // Update existing player
                    players[index!] = Player(
                      name: playerController.text + " 🤾‍♂️",
                      team: teamController.text + " 🟢",
                    );
                    showSnack("Player Updated ✏️", Colors.blue);
                  }
                });
                Navigator.pop(context);
              } else {
                showSnack("Please enter both fields ❗", Colors.red);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Remove Player
  void removePlayer(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Player ⚠"),
        content:
            const Text("Are you sure you want to remove this kabaddi player?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showSnack("Removal Cancelled ❌", Colors.blue);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                players.removeAt(index);
              });
              Navigator.pop(context);
              showSnack("Player Removed 🗑", Colors.red);
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🤾‍♂️ Kabaddi Players"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: players.isEmpty
                  ? const Center(
                      child: Text(
                        "No Players Added Yet",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final p = players[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.sports_kabaddi,
                                color: Colors.green, size: 40),
                            title: Text(
                              p.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(p.team),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () =>
                                      showPlayerDialog(player: p, index: index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removePlayer(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => showPlayerDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text("Add New Player"),
            ),
          ],
        ),
      ),
    );
  }
}