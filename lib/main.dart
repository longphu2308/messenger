import 'package:flutter/material.dart'; // import thư viện này thì mới sài được các widget có sẵn của Flutter như ListView, Scaffold

void main() {
  // khi chạy app nó sẽ chạy vào hàm main đầu tiên
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // để chạy app thì gọi hàm runApp truyền vào widget MaterialApp
    home: Scaffold(
      // widget MaterialApp có thuộc tính home truyền vào màn hình đầu tiên của app. Mỗi màn hình luôn bắt đầu bởi widget Scaffold
      appBar: AppBar(
        // Scaffold có thuộc tính appBar truyền vào 1 AppBar, AppBar có thuộc tính backgroundColor và title
        backgroundColor: Colors.white,
        title: const Text(
          'Messenger',
          style: TextStyle(fontWeight: FontWeight.bold),
        ), // title cần truyền vào 1 Widget, có thể truyền vào Image hoặc Text
      ),
      body: Container(
        color: Colors.blue,
        child: ListView.builder(
          // Scaffold có thuộc tính body, a truyền vào 1 ListView
          itemCount: 100,
          // ListView có thuộc tính itemCount quyết định listview đó có bao nhiêu item
          itemBuilder: (context, index) {
            // thuộc tính itemBuilder dùng để build UI của 1 item dựa vào index
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2.5),
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              // widget Center dùng để canh giữa widget child của nó
              child: Row(
                children: [
                  Container(child: const SizedBox(width: 10)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Long Phú' * 100,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            'Hello, friend.' * 100,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          )
                        ]),
                  )
                ],
              ), // widget Text dùng tạo ra Text
            );
          },
        ),
      ),
    ),
  ));
}
