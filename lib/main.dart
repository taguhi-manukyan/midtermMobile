import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MainApp());
}

class TaskItem{
  String subj;
  String desc;
  DateTime due;
  bool done;
  TaskItem({required this.subj, required this.desc, required this.due, this.done=false});
}

class TaskManager extends Cubit<List<TaskItem>>{
  TaskManager():super([]);
  void addTask(t){
    emit([...state, t]);
  }
  void toggleDone(i){
    var l = List<TaskItem>.from(state);
    l[i].done = !l[i].done;
    emit(l);
  }
}

GoRouter appRouter = GoRouter(
    routes: [
      GoRoute(path:'/', builder:(c,s)=>TaskListPage()),
      GoRoute(path:'/add', builder:(c,s)=>AddTaskPage()),
    ]
);

class MainApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_)=>TaskManager(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner:false,
        routerConfig:appRouter,
        title:'Homework Tracker',
        theme: ThemeData(
          useMaterial3:true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          appBarTheme: AppBarTheme(backgroundColor: Colors.purple[200], foregroundColor:Colors.white),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor:Colors.purple[200], foregroundColor:Colors.white),
          checkboxTheme: CheckboxThemeData(fillColor: MaterialStatePropertyAll(Colors.purple[200])),
          cardTheme: CardThemeData(
            elevation:4,
            shadowColor: Colors.purple.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),),
    );
  }}

class TaskListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text('Homework Tracker')),
      body: BlocBuilder<TaskManager,List<TaskItem>>(builder:(context,list){
        if(list.isEmpty) return Center(child: Text('No task added yet.'));
        return ListView.builder(
          itemCount:list.length,
          itemBuilder:(c,i){
            var item = list[i];
            return Card(
              color: item.done?Colors.green[50]:Colors.purple[50],
              child: ListTile(
                  title: Text(item.desc, style: TextStyle(decoration: item.done?TextDecoration.lineThrough:null)),
                  subtitle: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:[
                        Text(item.subj, style: TextStyle(color:Colors.purple[300])),
                        Text('Due: ${item.due.toLocal().toString().split(' ')[0]}')
                      ]
                  ),
                  trailing: Checkbox(
                      value: item.done,
                      onChanged:(_){context.read<TaskManager>().toggleDone(i);}
                  ),
                  onTap:(){context.read<TaskManager>().toggleDone(i);}
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>context.push('/add'),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget{
  @override
  _AddTaskPageState createState()=>_AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>{
  var formK=GlobalKey<FormState>();
  var subCtrl=TextEditingController();
  var descCtrl=TextEditingController();
  DateTime? selDate;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text('Add Homework')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key:formK,
          child: Column(
            children:[
              TextFormField(
                controller:subCtrl,
                decoration: InputDecoration(labelText:'Subject'),
                validator:(v)=>v!.isEmpty?'Enter subject':null,
              ),
              SizedBox(height:10),
              TextFormField(
                controller:descCtrl,
                decoration: InputDecoration(labelText:'Title'),
                validator:(v)=>v!.isEmpty?'Enter title':null,
              ),
              SizedBox(height:10),
              ElevatedButton(
                onPressed:() async{
                  var now = DateTime.now();
                  var d = await showDatePicker(context:context, initialDate:now, firstDate:now, lastDate:DateTime(now.year+2));
                  if(d!=null) setState(()=>selDate=d);
                },
                child: Text(selDate==null?'Select due date':'Due: ${selDate!.toLocal().toString().split(' ')[0]}'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed:(){
                  if(formK.currentState!.validate() && selDate!=null){
                    var t = TaskItem(subj:subCtrl.text, desc:descCtrl.text, due:selDate!);
                    context.read<TaskManager>().addTask(t);
                    context.pop();
                  }},
                child: Text('Save it'),
              ),
            ],
          ),
        ),),
    );}
}
