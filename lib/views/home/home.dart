import 'package:care_taker/views/home/messages/ChartUi.dart';

import '/exports/exports.dart';

import 'messages/Chart.dart';
import 'pages/map.dart';
import 'pages/LiveLocationFeed.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// pages
  List<Widget> pages = [
     const MapUIView(),
       const ChatScreen(receiverId: 'XRFnFEachfcaQPVVUor7d11AYkY2',),
    const GeolocatorWidget(),
  ];
  // controller
  final PageController _pageController = PageController();
  // page index
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return pages[index];
        },
        itemCount: pages.length,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          // 
          _pageController.jumpToPage(index);
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Observations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Live location feed',
          )
        ],
      ),
    );
  }
}
