import 'package:flutter/material.dart';
import 'package:noteskeeper/screens/add_note_screen.dart';
import 'package:noteskeeper/screens/edit_note_screen.dart';
import 'package:noteskeeper/providers/note_provider.dart';
import 'package:noteskeeper/widgets/note_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:noteskeeper/widgets/note_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


// ... (all previous imports)
import 'package:noteskeeper/widgets/note_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart'; // Added this import for TextPainter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  final GlobalKey _sortButtonKey = GlobalKey(); // GlobalKey to get widget's position

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<NoteProvider>(context, listen: false)
        .updateSearchQuery(_searchController.text);
  }

  String _getSortOrderText(NoteSortOrder order) {
    switch (order) {
      case NoteSortOrder.dateModifiedDescending:
        return 'Date modified';
      case NoteSortOrder.dateCreatedDescending:
        return 'Date created';
      default:
        return 'Date modified';
    }
  }

  void _showSortOptions(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    final RenderBox? renderBox = _sortButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final textPainter = TextPainter(
      text: TextSpan(
          text: _getSortOrderText(noteProvider.currentSortOrder),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
      ),
      // CORRECTED: Get TextDirection from the context
      textDirection: Directionality.of(context),
    )..layout();

    showMenu<NoteSortOrder>(
      context: context,
      // Adjust the horizontal position (left) to align with the arrow_drop_down icon
      position: RelativeRect.fromLTRB(
        offset.dx + textPainter.size.width + 4, // Aligns menu with the arrow icon
        offset.dy + size.height, // Place menu directly below the widget
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: <PopupMenuEntry<NoteSortOrder>>[
        PopupMenuItem<NoteSortOrder>(
          value: NoteSortOrder.dateModifiedDescending,
          child: const Text('Date modified'),
        ),
        PopupMenuItem<NoteSortOrder>(
          value: NoteSortOrder.dateCreatedDescending,
          child: const Text('Date created'),
        ),
      ],
      initialValue: noteProvider.currentSortOrder,
    ).then((NoteSortOrder? selectedOrder) {
      if (selectedOrder != null) {
        noteProvider.updateSortOrder(selectedOrder);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notes Keeper',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.menu_book, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.0)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.0)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Consumer<NoteProvider>(
                    builder: (context, noteProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            key: _sortButtonKey,
                            onTap: () => _showSortOptions(context),
                            child: Row(
                              children: [
                                Text(
                                  _getSortOrderText(noteProvider.currentSortOrder),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
                                const Icon(Icons.sort, size: 20, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.0)),

            Consumer<NoteProvider>(
              builder: (context, noteProvider, child) {
                final notes = noteProvider.notes;

                return notes.isEmpty
                    ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No notes yet. Tap + to add one!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                  ),
                )
                    : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final note = notes[index];
                        return NoteCard(
                          note: note,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditNoteScreen(
                                  note: note,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: notes.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}