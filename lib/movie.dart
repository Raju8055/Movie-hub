import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geeksynergy_task/company_info.dart';
import 'package:http/http.dart' as http;

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  List<dynamic> movies = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  Future<void> _fetchMovies() async {
    final response = await http.post(
      Uri.parse('https://hoblist.com/api/movieList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "category": "movies",
        "language": "kannada",
        "genre": "all",
        "sort": "voting"
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body)['result'];
        _isLoading = false; 
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Movies' : 'Company Info',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF281C9D), // Custom theme color
        elevation: 4,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     // Implement search functionality
          //     print('Search tapped');
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.settings),
          //   onPressed: () {
          //     // Implement settings functionality
          //     print('Settings tapped');
          //   },
          // ),
        ],
      ),
      body: _selectedIndex == 0
          ? _isLoading
              ? Center(child: CircularProgressIndicator())
              : movies.isEmpty
                  ? Center(child: Text('No movies available.'))
                  : _buildMoviesList()
          : CompanyInfoPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Company Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMoviesList() {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        var movie = movies[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Votes
                Column(
                  children: [
                    const Icon(Icons.arrow_drop_up_outlined, color: Colors.black, size: 40),
                    Text(
                      movie['voting'].toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black, size: 40),
                    const Text('Votes'),
                  ],
                ),
                SizedBox(width: 16),
                // Movie Poster
                Image.network(
                  movie['poster'],
                  height: 120,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                // Movie Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text('Genre: ${movie['genre']}'),
                      Text('Director: ${movie['director'].join(", ")}'),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          _watchTrailer(movie['trailerLink']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Watch Trailer', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _watchTrailer(String trailerUrl) {
    print('Watching trailer: $trailerUrl');
  }
}
