import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdvancedScrollView3 extends StatefulWidget {
  @override
  State<AdvancedScrollView3> createState() => _AdvancedScrollViewState();
}

class _AdvancedScrollViewState extends State<AdvancedScrollView3> {
  late ScrollController _scrollController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool _headerCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50) {
            _headerCollapsed = true;
          } else if (_scrollController.position.pixels <=
              _scrollController.position.minScrollExtent + 50) {
            _headerCollapsed = false;
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  String formatCurrency(double amount) {
    final NumberFormat format =
        NumberFormat.currency(locale: 'es_CL', symbol: '');
    String formatted = format.format(amount);
    formatted = formatted
        .replaceAll('\$', '')
        .replaceAll(',', ''); // Eliminar símbolo y separador de miles
    return '\$${formatted.substring(0, formatted.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.minScrollExtent) {
              setState(() {
                _headerCollapsed = false;
              });
            }
            return false;
          },
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leadingWidth: 60,
                  backgroundColor: Colors.blue,
                  leading: Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        // Acciones adicionales aquí
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                            'assets/images/profile_pic.png'), // Ruta a tu imagen
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        // Acciones adicionales aquí
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 20, top: 10),
                        child: Icon(Icons.notifications,
                            color: Colors.white, size: 30),
                      ),
                    )
                  ],
                  stretch: true,
                  expandedHeight: 280.0,
                  collapsedHeight: _headerCollapsed ? 70 : null,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                      StretchMode.fadeTitle,
                    ],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.0, -2.0),
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue,
                                Colors.blueAccent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16.0, // Posiciona el contenido más abajo
                          left: 16.0,
                          right: 16.0,
                          child: buildHeaderContent(context),
                        ),
                      ],
                    ),
                    centerTitle: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Mis productos',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: PageView.builder(
              controller: _pageController,
              itemCount: 10, // Reemplaza con la longitud real de tus productos
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 200,
                            color: Colors.grey,
                            child: Center(child: Text('Card $index')),
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 100,
                            color: Colors.grey,
                            child: Center(child: Text('Info Card $index')),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 2000,
                          color: Colors.grey,
                          child:
                              Center(child: Text('Transactions List $index')),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance Total:',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 10),
          Text(formatCurrency(1842081),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildIndicator(
                icon: Icons.arrow_upward,
                title: 'Ingresado',
                amount: 12000,
                context: context,
                isPositive: true,
              ),
              SizedBox(width: 16),
              buildIndicator(
                icon: Icons.arrow_downward,
                title: 'Gastado',
                amount: 6000,
                context: context,
                isPositive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIndicator({
    required IconData icon,
    required String title,
    required double amount,
    required BuildContext context,
    required bool isPositive,
  }) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon,
                  color: isPositive ? Colors.green : Colors.red, size: 30),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white70)),
                  Text(formatCurrency(amount),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
