import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  //TODO: delete _appIdeas; use Firebase Database
  final _appIdeas = [
    MockAppIdea(title: 'first idea'),
    MockAppIdea(title: 'second idea'),
  ];

  @override
  void dispose() {
    _textFieldController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared ideas'),
      ),
      body: _buildIdeaList(context),
    );
  }

  Widget _buildIdeaList(BuildContext context) {
    //TODO: use Firebase to load and show ideas
    return ListView.separated(
      itemCount: _appIdeas.length + 1,
      itemBuilder: (_, index) {
        return index == _appIdeas.length
            ? _buildAddIdeaTile(context)
            : _buildIdeaTile(_appIdeas[index]);
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }

  ListTile _buildIdeaTile(MockAppIdea idea) {
    return ListTile(
      title: Text(idea.title),
      trailing: Text(idea.votes.toString()),
      onTap: () {
        //TODO: increment voting for the idea in Firebase
        setState(() => idea.votes++);
      },
    );
  }

  ListTile _buildAddIdeaTile(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).primaryColor,
      leading: Icon(Icons.note_add_rounded, color: Colors.white),
      title: Text(
        'Add idea',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: () => _displayTextInputDialog(context),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    _clearTextFieldAndSetFocusInIt();
    return showDialog(
      context: context,
      builder: (context) => _buildAlertDialog(context),
    );
  }

  void _clearTextFieldAndSetFocusInIt() {
    _textFieldController.text = '';
    Future.delayed(const Duration(milliseconds: 250), () {
      _textFieldFocusNode.requestFocus();
    });
  }

  AlertDialog _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Your new idea'),
      content: TextField(
        focusNode: _textFieldFocusNode,
        onSubmitted: (_) => _addIdeaAndRemoveDialog(context),
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Title of your idea"),
      ),
    );
  }

  void _addIdeaAndRemoveDialog(BuildContext context) {
    //TODO: save new idea in Firebase
    setState(() {
      _appIdeas.add(MockAppIdea(title: _textFieldController.text));
    });
    Navigator.of(context).pop();
  }
}

class MockAppIdea {
  String title;
  int votes;

  MockAppIdea({@required this.title, this.votes = 0});
}
