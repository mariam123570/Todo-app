import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app1/shared/cubit/cubit.dart';



Widget defaultButton({
   double width = double.infinity,
   Color background = Colors.blue,
   required Function() function,
   bool isUpperCase = true,
   required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      color: background,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  required Function validate,
  required String label,
  required IconData prefix,
})=>TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted: onSubmit!(),
  onChanged: onChange!(),
  validator: validate(),
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
    prefixIcon: Icon(
      prefix,
    ),
  ),
);

Widget buildTaskItem(Map model , context) => Builder(
  builder: (context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}',
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.teal,
              ),
              onPressed:(){
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              }
          ),
          IconButton(
            icon: Icon(
              Icons.archive_outlined,
              color: Colors.indigo,
            ),
            onPressed: (){
              AppCubit.get(context).updateData(
                status: 'archived',
                id: model['id'],
              );
            },
          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).deleteData(id: model['id']);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
);


