import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: QuoteHomePage(),
    );
  }
}

class QuoteHomePage extends StatefulWidget {
  @override
  _QuoteHomePageState createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  final List<String> quotes = [
    "Believe in yourself and all that you are.",
    "Act as if what you do makes a difference. It does.",
    "Success is not how high you have climbed, but how you make a positive difference.",
    "Stay positive, work hard, and make it happen.",
    "Your limitation—it’s only your imagination.",
    "Stay away from those people who try to disparage your ambitions. Small minds will always do that, but great minds will give you a feeling that you can become great too.",
    "When you give joy to other people, you get more joy in return. You should give a good thought to the happiness that you can give out.",
    "When you change your thoughts, remember to also change your world.",
    "It is only when we take chances that our lives improve. The initial and the most difficult risk we need to take is to become honest.",
"Nature has given us all the pieces required to achieve exceptional wellness and health, but has left it to us to put these pieces together."
  ];

  late String currentQuote;
  List<String> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    loadRandomQuote();
    loadFavorites();
  }

  void loadRandomQuote() {
    final randomIndex = Random().nextInt(quotes.length);
    setState(() {
      currentQuote = quotes[randomIndex];
    });
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs.getStringList('favorites') ?? [];
    });
  }

  void saveFavoriteQuote() async {
    if (!favoriteQuotes.contains(currentQuote)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      favoriteQuotes.add(currentQuote);
      await prefs.setStringList('favorites', favoriteQuotes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote added to favorites!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote already in favorites!')),
      );
    }
  }

  void shareQuote() {
    Share.share(currentQuote); // Share the current quote
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of the Day'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteQuotesPage(favorites: favoriteQuotes),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentQuote,
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: loadRandomQuote,
              icon: Icon(Icons.refresh),
              label: Text('New Quote'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: saveFavoriteQuote,
              icon: Icon(Icons.favorite),
              label: Text('Add to Favorites'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: shareQuote, // Call the share method
              icon: Icon(Icons.share),
              label: Text('Share Quote'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteQuotesPage extends StatelessWidget {
  final List<String> favorites;

  FavoriteQuotesPage({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: favorites.isEmpty
          ? Center(child: Text('No favorite quotes yet!'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text(favorites[index]),
                );
              },
            ),
    );
  }
}
