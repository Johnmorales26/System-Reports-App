import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/ui/expensesReportModule/expenses_report_screen.dart';
import 'package:system_reports_app/ui/homeModule/home_view_model.dart';
import 'package:system_reports_app/ui/homeModule/widgets/reports_inner_screen.dart';
import 'package:system_reports_app/ui/profileModule/profile_screen.dart';
import 'package:system_reports_app/ui/registerModule/user_privileges.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_screen.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:system_reports_app/ui/widgets/item_task.dart';

import '../../data/local/task_entity.dart';
import '../appModule/assets.dart';
import '../reportModule/report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String route = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);
    return FutureBuilder(
        future: provider.getCurrentUserByFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _CustomScreen(
              title: 'Searching for User',
              description:
                  'We are currently searching for the user account. Please wait a moment.',
              resource: Assets.imgSearch,
              isError: false,
            );
          } else if (snapshot.hasError) {
            return _CustomScreen(
              title: 'Error',
              description:
                  'An error occurred while searching for the user. Please try again later.',
              resource: Assets.imgError429,
              isError: true,
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _HomeScreen(snapshot.data!);
            } else {
              return _CustomScreen(
                  title: 'User Not Found',
                  description:
                      'Sorry, we couldn\'t find the user account you were looking for. Please verify the information and try again.',
                  resource: Assets.imgError404,
                  isError: true);
            }
          } else {
            return _CustomScreen(
                title: 'User Not Found',
                description:
                    'Sorry, we couldn\'t find the user account you were looking for. Please verify the information and try again.',
                resource: Assets.imgError404,
                isError: true);
          }
        });
  }
}

class _CustomScreen extends StatelessWidget {
  final String title;
  final String description;
  final String resource;
  final bool isError;

  const _CustomScreen(
      {required this.title,
      required this.description,
      required this.resource,
      required this.isError});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);
    Widget barLoading = Container();
    Widget buttonError = Container();

    if (isError) {
      buttonError = ElevatedButton(
          onPressed: () {
            provider.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, SignInScreen.route, (route) => false);
          },
          child: const Text('Go to Main Page'));
    } else {
      barLoading = const LinearProgressIndicator();
    }

    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: Dimens.commonPaddingDefault),
                  barLoading,
                  const SizedBox(height: Dimens.commonPaddingDefault),
                  Text(description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: Dimens.commonPaddingDefault),
                  SvgPicture.asset(resource),
                  const SizedBox(height: Dimens.commonPaddingDefault),
                  buttonError
                ],
              ))),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final UserDatabase snapshot;

  const _HomeScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);

    Widget adminMenu = _AdminMenu(snapshot.privileges);
    Widget bottomBar = Container();

    if (snapshot.privileges == UserPrivileges.admin) {
      bottomBar = NavigationBar(
          onDestinationSelected: (int index) {
            provider.updateIndex(index);
          },
          selectedIndex: provider.currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.file_copy),
              selectedIcon: Icon(Icons.file_copy_outlined),
              label: 'Reports',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            )
          ]);
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text([
            'System Reports',
            'Reports',
            'Perfil de Usuario'
          ][provider.currentPageIndex]),
          actions: [
            FutureBuilder(
                future: provider.fetchPendingTaskByUser(snapshot.fseName),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DataEntry>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {
                    final dataEntryList = snapshot.data!;
                    if (dataEntryList.isEmpty) {
                      return IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications));
                    } else {
                      return _CascadingMenuState(dataEntryList: dataEntryList);
                    }
                  } else {
                    return Container();
                  }
                }),
            IconButton(
                onPressed: () {
                  provider.signOut();
                  Navigator.pushReplacementNamed(context, SignInScreen.route);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: [
          Padding(
            padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
            child: Column(children: [adminMenu, _TaskList()]),
          ),
          const ReportsInnerScreen(),
          const ProfileScreen()
        ][provider.currentPageIndex],
        bottomNavigationBar: bottomBar);
  }
}

class _AdminMenu extends StatefulWidget {
  const _AdminMenu(this.privileges);

  final UserPrivileges privileges;

  @override
  __AdminMenuState createState() => __AdminMenuState();
}

class __AdminMenuState extends State<_AdminMenu> {
  bool showListTiles = true; // State variable to control visibility

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.commonPaddingMin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reports',
                          style: Theme.of(context).textTheme.headlineLarge),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showListTiles = !showListTiles; // Toggle visibility
                          });
                        },
                        icon: Icon(showListTiles
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.commonPaddingMin),
                  Text(
                    'Select the type of report you want to create.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            if (showListTiles) ...[
              const SizedBox(height: Dimens.commonPaddingDefault),
              if (widget.privileges == UserPrivileges.admin)
                ListTile(
                  leading: const Icon(Icons.add_box_outlined),
                  title: const Text('New Report'),
                  subtitle: const Text('Create a new report from scratch.'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.pushNamed(context, ReportScreen.route),
                ),
              if (widget.privileges == UserPrivileges.admin)
                ListTile(
                  leading: const Icon(Icons.computer_outlined),
                  title: const Text('Computer Report'),
                  subtitle: const Text('Create a report for a computer.'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.pushNamed(context, ReportScreen.route),
                ),
              if (widget.privileges == UserPrivileges.admin)
                ListTile(
                  leading: const Icon(Icons.car_crash_outlined),
                  title: const Text('Vehicle Report'),
                  subtitle: const Text('Create a report for a vehicle.'),
                  onTap: () => Navigator.pushNamed(context, ReportScreen.route),
                ),
              if (widget.privileges == UserPrivileges.user)
                ListTile(
                  leading: const Icon(Icons.money_outlined),
                  title: const Text('Expense Report'),
                  subtitle: const Text('Create a report for expenses.'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () =>
                      Navigator.pushNamed(context, ExpensesReportScreen.route),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return FutureBuilder<Stream<QuerySnapshot<Map<String, dynamic>>>>(
      future: viewModel.getAllTask(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final stream = snapshot.data;

        if (stream == null) {
          return const Center(child: Text('No data available'));
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (streamSnapshot.hasError) {
              return Center(child: Text('Error: ${streamSnapshot.error}'));
            }

            final data = streamSnapshot.data;
            final tasks = data?.docs
                    .map((doc) => TaskEntity.fromJson(doc.data()))
                    .toList() ??
                [];

            if (tasks.isEmpty) {
              return const Center(child: Text('No tasks available'));
            }

            return Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ItemTask(taskEntity: task);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _CascadingMenuState extends StatefulWidget {
  final List<DataEntry> dataEntryList;

  const _CascadingMenuState({required this.dataEntryList});

  @override
  State<StatefulWidget> createState() => _CascadingMenu();
}

class _CascadingMenu extends State<_CascadingMenuState> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DataEntry>(
      onSelected: (DataEntry selectedEntry) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportScreen(dataEntry: selectedEntry)));
      },
      itemBuilder: (BuildContext context) {
        return widget.dataEntryList.map((DataEntry dataEntry) {
          return PopupMenuItem<DataEntry>(
            value: dataEntry,
            child: ListTile(
              title: Text(dataEntry.client),
              subtitle: Text(dataEntry.referenceNumber),
            ),
          );
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Añade espacio alrededor del botón
        child: Badge.count(
          count: widget.dataEntryList.length,
          child: const Icon(Icons.notifications),
        ),
      ),
    );
  }
}
