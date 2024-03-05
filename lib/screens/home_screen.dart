import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivpod_ex_5_yt/models/person.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    ageController.dispose();
  }

  Future<Person?> handlePopupWindow(BuildContext context, Person? person) {
    nameController.text = person?.name ?? '';
    ageController.text = person?.age.toString() ?? '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('create a Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Enter Name Here"),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Enter Age Here"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(Person(
                      name: nameController.text,
                      age: int.parse(ageController.text)));
                },
                child: const Text('Save')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, child) {
        final personList = ref.watch(personProvider);
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('List of Persons'),
              const Divider(),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: personList.length,
                  itemBuilder: (context, index) {
                    final person = personList[index];
                    return ListTile(
                      title: GestureDetector(
                          onTap: () async {
                            final updatedPerson =
                                await handlePopupWindow(context, person);

                            if (updatedPerson != null) {
                              ref
                                  .read(personProvider.notifier)
                                  .updatePerson(updatedPerson);
                            }
                          },
                          child: Text(person.displayName)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref
                              .read(personProvider.notifier)
                              .removePerson(person.uuid);
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedPerson = await handlePopupWindow(context, null);
          if (updatedPerson != null) {
            ref.read(personProvider.notifier).addPerson(updatedPerson);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
