import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(          // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => RandomWords(),
        '/Screen2':(context) => WordEditor()
      },
    );
  }

}
class WordEditor extends StatefulWidget {
  const WordEditor({Key? key}) : super(key: key);
  static const routeName = '/';
  @override
  State<WordEditor> createState() => _WordEditorState();
}

class _WordEditorState extends State<WordEditor> {
  @override
  Widget build(BuildContext context) {
    final editwords = ModalRoute.of(context)!.settings.arguments as WordPair;
    final mycontroller1 = TextEditingController(text: editwords.getFirstWord);
    final mycontroller2 = TextEditingController(text: editwords.getSecondWord);
    return Container(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Edit'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back',
                  onPressed:()=> Navigator.pushNamed(context,'/') ),
            ],
          ),
          body: Center(
              child: Column(
                 children: [
                Text('You are editing: ${editwords.toString()}'),
                TextFormField(
                  controller: mycontroller1,
                ),
                TextFormField(
                  controller: mycontroller2,
                ),
                   ElevatedButton(
                       child: Text('Done'),
                       onPressed:(){
                         Navigator.pop(context);
                         setState(() {
                           editwords.setFirstWord(mycontroller1.text);
                           editwords.setSecondWord(mycontroller2.text);
                         });

                       } )
                 ],

              ) )
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  @override
  WordPairRepo pairRepository = WordPairRepo();
  final _saved = <WordPair>{};// NEW
  final _biggerFont = const TextStyle(fontSize: 18); // NEW
  bool isGrid = true;

  _goEdit(WordPair pair){
    final WordPair edited = pair;
    Navigator.pushNamed(context, '/Screen2', arguments: edited);
    setState(() {
      pair = edited;
    });
  }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.toString(),
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    pairRepository.addpairs(pairRepository);
    return Scaffold (
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
          IconButton(
            icon: const Icon(Icons.grid_view ),
            onPressed: (){
              setState(() {
                isGrid = !isGrid;
              });
            },
            tooltip: 'Change layout',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() => isGrid
      ? ListView.builder(
    padding: const EdgeInsets.all(16),
    itemBuilder: (context, i) {
      return _buildRow(pairRepository.getPairByIndex(i));
    },
  )
      :
  GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 10),
    padding: const EdgeInsets.all(16),
    itemBuilder: (context, i) {
      return Card(
        child: _buildRow(pairRepository.getPairByIndex(i)),
      );


    },
  );


  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.toString() ,
        style: _biggerFont,
      ),
      trailing: IconButton(
          icon: (alreadySaved? const Icon(Icons.favorite) : const Icon(Icons.favorite_border)),
          color: alreadySaved ? Colors.red : null,
          tooltip: 'Save',
          onPressed: () => setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            }
            else {
              _saved.add(pair);
            }
          }
          )
      ),
      onLongPress: (){
        setState(() {
          _saved.remove(pair);
          pairRepository.removepair(pair);
        });
      },
      onTap: (){ _goEdit(pair);
      },
    );
  }
}
class WordPairRepo{
  final List<WordPair> words = [];
  ///Construtor

  ///Método que retorna a lista completa de pares
  getAll(){
    return words;
  }
  ///Retorna o primeiro par da lista
  getFirstPair(){
    return words[0]; /* return words[0].toStr()*/
  }
  /// Retorna o par pelo index
  getPairByIndex(int idx){
    return words[idx];
  }
  ///Getter e setters da primeira(FW)e segunda palavra(SW) do par
  getByIndexFW(int idx){
    return words[idx].getFirstWord;
  }
  getByIndexSW(int idx){
    return words[idx].getSecondWord;
  }
  setByIndexFW(int idx, newword){
    words[idx].setFirstWord(newword);
  }
  setByIndexSW(int idx, newword){
    words[idx].setSecondWord(newword);
  }
  ///Adiciona nova WordPair
  addNew(WordPair pair ){
    words.add(pair);
  }
  ///Remove o item da lista de pares
  removepair(pair){
    words.remove(pair);
  }
  /// Adiciona os objetos da class WordPair no repositório
  void addpairs(repository){
    repository.addNew(WordPair('Earth','Waltz'));
    repository.addNew(WordPair('Mercury','Jazz'));
    repository.addNew(WordPair('Venus','Blues'));
    repository.addNew(WordPair('Mars','Funk'));
    repository.addNew(WordPair('Neptun','Samba'));
    repository.addNew(WordPair('Uranus','Swing'));
    repository.addNew(WordPair('Jupiter','Bebop'));
    repository.addNew(WordPair('Pluto','Soul'));
    repository.addNew(WordPair('Saturn','Gypsy'));
    repository.addNew(WordPair('Charon','Samba'));
    repository.addNew(WordPair('Eris','Fusion'));
    repository.addNew(WordPair('Orchus','Acid'));
    repository.addNew(WordPair('Sedna','Baroque'));
    repository.addNew(WordPair('Quaoar','Country'));
    repository.addNew(WordPair('Ixion','Classical'));
    repository.addNew(WordPair('Varuna','Ragtime'));
    repository.addNew(WordPair('Ceres','Rock'));
    repository.addNew(WordPair('Pallas','House'));
    repository.addNew(WordPair('Vesta','Punk'));
    repository.addNew(WordPair('Hygiea','Dance'));
  }
}
///Classe pares de palavras, recebe duas strings na construção
class WordPair{
  ///Atributos
  String _first;
  String _second;
  ///construtor
  WordPair(this._first,this._second);
  ///Método que retorna o par concatenado ex. "TeoremaAntigo"
  @override
  String toString(){
    return "$_first$_second";
  }
  ///Geters and setters
  String get getFirstWord{
    return _first;
  }
  setFirstWord(String firstword){
    _first = firstword;
  }
  String get getSecondWord{
    return _second;
  }
  setSecondWord(String secondword){
    _second = secondword;
  }

}

