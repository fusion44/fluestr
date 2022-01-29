import '../models/relay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../relay_repository.dart';

class EditRelaysPage extends StatefulWidget {
  const EditRelaysPage({Key? key}) : super(key: key);

  @override
  _EditRelaysPageState createState() => _EditRelaysPageState();
}

class _EditRelaysPageState extends State<EditRelaysPage> {
  late final RelayRepository _relayRepository;

  @override
  void initState() {
    _relayRepository = RepositoryProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Relays')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not implemented :(')),
        ),
      ),
      body: Center(
        heightFactor: 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 16,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'URL',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: _constrainWidth(
                    Text(
                      'Read',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: _constrainWidth(
                    Text(
                      'Write',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: _constrainWidth(
                    Text(
                      'Active',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                for (var r in _relayRepository.relays)
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: Text(
                            r.url
                                .replaceAll('wss://', '')
                                .replaceAll('ws://', ''),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      DataCell(_constrainWidth(_buildSwitchRead(r, theme))),
                      DataCell(_constrainWidth(_buildSwitchWrite(r, theme))),
                      DataCell(_constrainWidth(_buildSwitchActive(r, theme))),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _constrainWidth(Widget w) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 50),
      child: w,
    );
  }

  Widget _buildSwitchRead(Relay r, ThemeData theme) {
    return Switch(
      value: r.read,
      onChanged: r.active
          ? (value) => setState(() {
                _relayRepository.toggleRelayReadState(r);
              })
          : null,
    );
  }

  Widget _buildSwitchWrite(Relay r, ThemeData theme) {
    return Switch(
      value: r.write,
      onChanged: r.active
          ? (value) => setState(() {
                _relayRepository.toggleRelayWriteState(r);
              })
          : null,
    );
  }

  Widget _buildSwitchActive(Relay r, ThemeData theme) {
    return Switch(
      value: r.active,
      onChanged: (value) => setState(() {
        _relayRepository.toggleRelayActiveState(r);
      }),
    );
  }
}
