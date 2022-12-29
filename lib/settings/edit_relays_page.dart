import '../common/models/relay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/relays/relays_bloc.dart';
import 'widgets/add_relay_dialog.dart';

class EditRelaysPage extends StatefulWidget {
  const EditRelaysPage({Key? key}) : super(key: key);

  @override
  _EditRelaysPageState createState() => _EditRelaysPageState();
}

class _EditRelaysPageState extends State<EditRelaysPage> {
  late final RelayBloc _relayBloc;

  @override
  void initState() {
    _relayBloc = RelayBloc(RepositoryProvider.of(context));
    _relayBloc.add(LoadRelays());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Relays')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddRelayDialog(context),
      ),
      body: Center(
        heightFactor: 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlocBuilder<RelayBloc, RelaysState>(
              bloc: _relayBloc,
              builder: (context, state) {
                if (state is RelaysInitial) {
                  return Center(child: Text('loading'));
                } else if (state is RelaysLoadedState) {
                  return _buildDataTable(state, theme);
                } else {
                  return Center(child: Text('Unknown state: $state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  DataTable _buildDataTable(RelaysLoadedState state, ThemeData theme) {
    return DataTable(
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
        DataColumn(label: Container())
      ],
      rows: <DataRow>[
        for (var r in state.relays)
          DataRow(
            cells: <DataCell>[
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 150),
                  child: Text(
                    r.url.replaceAll('wss://', '').replaceAll('ws://', ''),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              DataCell(_constrainWidth(_buildSwitchRead(r, theme))),
              DataCell(_constrainWidth(_buildSwitchWrite(r, theme))),
              DataCell(_constrainWidth(_buildSwitchActive(r, theme))),
              DataCell(
                _constrainWidth(
                  IconButton(
                    onPressed: () => _relayBloc.add(RemoveRelay(r)),
                    icon: Icon(Icons.delete_forever),
                  ),
                ),
              ),
            ],
          ),
      ],
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
      onChanged:
          r.active ? (_) => _relayBloc.add(ToggleRelayReadState(r)) : null,
    );
  }

  Widget _buildSwitchWrite(Relay r, ThemeData theme) {
    return Switch(
      value: r.write,
      onChanged:
          r.active ? (_) => _relayBloc.add(ToggleRelayWriteState(r)) : null,
    );
  }

  Widget _buildSwitchActive(Relay r, ThemeData theme) {
    return Switch(
      value: r.active,
      onChanged: (_) => _relayBloc.add(ToggleRelayActiveState(r)),
    );
  }

  void _showAddRelayDialog(BuildContext context) async {
    String relayUrl = await showDialog(
      context: context,
      builder: (BuildContext dlgContext) => AddRelayDialog(),
    );

    if (relayUrl.isEmpty) return;

    if (relayUrl.startsWith('http://')) {
      relayUrl = relayUrl.replaceFirst('http://', 'ws://');
    }

    if (relayUrl.startsWith('https://')) {
      relayUrl = relayUrl.replaceFirst('https://', 'wss://');
    }

    if (!relayUrl.startsWith('ws://') && !relayUrl.startsWith('wss://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber[600],
          content: Text(
              'Unsupported URL scheme "https". "ws" or "wss" is required.'),
        ),
      );
      return;
    }

    _relayBloc.add(AddRelay(Relay(url: relayUrl, read: true, write: true)));
  }
}
