import 'package:flutter/material.dart';

void main() => runApp(const GiaPhaApp());

class Member {
  Member(this.name, this.generation, this.branch, this.birthYear);
  final String name;
  final int generation;
  final int branch;
  final String birthYear;
}

class GiaPhaApp extends StatelessWidget {
  const GiaPhaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Gia Phả Việt 4.0',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B50)), useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  final members = <Member>[
    Member('Trần Văn Tổ', 1, 1, '1900'),
    Member('Trần Văn An', 2, 1, '1930'),
    Member('Trần Thị Bình', 3, 1, '1960'),
  ];
  final posts = <String>['Chào mừng đến với Gia Phả Việt 4.0!'];
  final transactions = <(String, int)>[('Đóng góp quỹ mẫu', 500000)];
  String search = '';

  Future<String?> ask(String title, {String hint = 'Nhập nội dung'}) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: hint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Lưu')),
        ],
      ),
    );
  }

  Future<void> addMember() async {
    final name = await ask('Thêm thành viên', hint: 'Họ và tên');
    if (name == null || name.isEmpty || !mounted) return;
    final generationText = await ask('Đời thứ', hint: 'Ví dụ: 4');
    if (!mounted) return;
    final branchText = await ask('Chi họ', hint: 'Ví dụ: 1');
    if (!mounted) return;
    final year = await ask('Năm sinh', hint: 'Ví dụ: 1993');
    if (!mounted) return;
    setState(() => members.add(Member(name, int.tryParse(generationText ?? '') ?? 1, int.tryParse(branchText ?? '') ?? 1, year ?? '')));
  }

  Future<void> addPost() async {
    final content = await ask('Đăng bài', hint: 'Nội dung bài viết');
    if (content != null && content.isNotEmpty) setState(() => posts.insert(0, content));
  }

  Future<void> addTransaction() async {
    final title = await ask('Tên khoản thu/chi', hint: 'Ví dụ: Đóng đinh');
    if (title == null || title.isEmpty || !mounted) return;
    final amount = await ask('Số tiền (VNĐ)', hint: 'Thu: 100000, chi: -100000');
    final value = int.tryParse(amount ?? '');
    if (value != null) setState(() => transactions.insert(0, (title, value)));
  }

  Widget home() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Gia Phả Việt 4.0', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('Kết nối dòng tộc • Gìn giữ cội nguồn'),
    const SizedBox(height: 18),
    Card(child: ListTile(leading: const Icon(Icons.groups), title: const Text('Thành viên dòng họ'), trailing: Text('${members.length}'))),
    Card(child: ListTile(leading: const Icon(Icons.account_tree), title: const Text('Số thế hệ'), trailing: Text('${members.map((e) => e.generation).toSet().length}'))),
    Card(child: ListTile(leading: const Icon(Icons.account_balance_wallet), title: const Text('Quỹ hiện tại'), subtitle: Text('${transactions.fold<int>(0, (sum, item) => sum + item.$2)} VNĐ'))),
    const SizedBox(height: 20),
    const Text('Đây là bản thử nghiệm. Dữ liệu chưa được lưu lâu dài.', style: TextStyle(color: Colors.deepOrange)),
  ]);

  Widget familyTree() {
    final sorted = [...members]..sort((a, b) => a.generation.compareTo(b.generation));
    return ListView(children: [
      for (final person in sorted)
        Padding(
          padding: EdgeInsets.only(left: 12.0 + (person.generation - 1).clamp(0, 6) * 12.0, right: 12, top: 5),
          child: Card(child: ListTile(leading: const Icon(Icons.account_tree), title: Text(person.name), subtitle: Text('Đời ${person.generation} • Chi ${person.branch} • Sinh ${person.birthYear}'))),
        ),
    ]);
  }

  Widget memberList() => Column(children: [
    Padding(padding: const EdgeInsets.all(12), child: TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tìm tên thành viên', border: OutlineInputBorder()), onChanged: (v) => setState(() => search = v))),
    Expanded(child: ListView(children: [
      for (final person in members.where((e) => e.name.toLowerCase().contains(search.toLowerCase())))
        Card(child: ListTile(title: Text(person.name), subtitle: Text('Đời ${person.generation} • Chi ${person.branch} • Sinh ${person.birthYear}'))),
    ])),
  ]);

  Widget fund() => ListView(padding: const EdgeInsets.all(12), children: [
    Card(child: ListTile(title: const Text('Số dư quỹ mẫu'), subtitle: Text('${transactions.fold<int>(0, (sum, item) => sum + item.$2)} VNĐ'))),
    for (final t in transactions) Card(child: ListTile(title: Text(t.$1), trailing: Text('${t.$2} VNĐ', style: TextStyle(color: t.$2 >= 0 ? Colors.green : Colors.red)))),
  ]);

  Widget feed() => ListView(padding: const EdgeInsets.all(12), children: [
    for (final post in posts) Card(child: Padding(padding: const EdgeInsets.all(18), child: Text(post))),
  ]);

  @override
  Widget build(BuildContext context) {
    final screens = [home(), familyTree(), memberList(), fund(), feed()];
    const titles = ['Trang chủ', 'Cây gia phả', 'Thành viên', 'Quỹ dòng họ', 'Bảng tin'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[tab])),
      body: screens[tab],
      floatingActionButton: tab == 2 || tab == 1 || tab == 3 || tab == 4
          ? FloatingActionButton(
              onPressed: () {
                if (tab == 1 || tab == 2) addMember();
                if (tab == 3) addTransaction();
                if (tab == 4) addPost();
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Trang chủ'),
          NavigationDestination(icon: Icon(Icons.account_tree), label: 'Gia phả'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Thành viên'),
          NavigationDestination(icon: Icon(Icons.savings), label: 'Quỹ'),
          NavigationDestination(icon: Icon(Icons.forum), label: 'Bảng tin'),
        ],
      ),
    );
  }
}
