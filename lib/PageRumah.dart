import 'package:flutter/material.dart';
import 'package:formsliving/PageDetailRumah.dart';

class PageRumah extends StatefulWidget {
  @override
  _PageRumahState createState() => _PageRumahState();
}

class _PageRumahState extends State<PageRumah> {
  bool isSidebarOpen = true;

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Rumah'),
      ),
      body: Row(
        children: [
          if (isSidebarOpen)
            if (isSidebarOpen)
            Expanded(
              flex: 1,
              child: Drawer(
                  child: SideBar(),
              ),
            ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 3, // Number of columns
                children: List.generate(10, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageDetailRumah(index: index + 1),
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.jpg'), // Replace with your image path
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                'Header ${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                'Footer ${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleSidebar,
        child: Icon(isSidebarOpen ? Icons.arrow_back : Icons.arrow_forward),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Advanced Search',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Tambahkan widget-widget advanced search di sini
        ],
      ),
    );
  }
}
