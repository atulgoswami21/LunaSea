import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LSDrawer extends StatelessWidget {
    final String page;

    LSDrawer({
        @required this.page,
    });

    @override
    Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: Database.lunaSeaBox.listenable(keys: [LunaSeaDatabaseValue.ENABLED_PROFILE.key]),
        builder: (context, lunaBox, widget) {
            return ValueListenableBuilder(
                valueListenable: Database.indexersBox.listenable(),
                builder: (context, indexerBox, widget) {
                    ProfileHiveObject profile = Database.profilesBox.get(lunaBox.get(LunaSeaDatabaseValue.ENABLED_PROFILE.key));
                    return Drawer(
                        child: ListView(
                            children: _getDrawerEntries(context, profile, (ModuleFlags.SEARCH && (indexerBox as Box).length > 0)),
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                            physics: ClampingScrollPhysics(),
                        ),
                    );
                }
            );
        }
    );

    List<Widget> _getDrawerEntries(BuildContext context, ProfileHiveObject profile, bool showIndexerSearch) {
        return <Widget>[
            UserAccountsDrawerHeader(
                accountName: LSTitle(text: 'LunaSea'),
                accountEmail: ValueListenableBuilder(
                    valueListenable: Database.lunaSeaBox.listenable(keys: [LunaSeaDatabaseValue.ENABLED_PROFILE.key]),
                    builder: (context, lunaBox, widget) => ValueListenableBuilder(
                        valueListenable: Database.profilesBox.listenable(),
                        builder: (context, profilesBox, widget) => Padding(
                            child: DropdownButton(
                                icon: LSIcon(icon: Icons.arrow_drop_down, color: Colors.white70),
                                underline: Container(),
                                value: lunaBox.get(LunaSeaDatabaseValue.ENABLED_PROFILE.key),
                                items: (profilesBox as Box).keys.map<DropdownMenuItem<String>>((dynamic value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                )).toList(),
                                onChanged: (value) {
                                    lunaBox.put(LunaSeaDatabaseValue.ENABLED_PROFILE.key, value);
                                },
                                isDense: true,
                                isExpanded: true,
                                selectedItemBuilder: (context) => (profilesBox as Box).keys.map<DropdownMenuItem<String>>((dynamic value) => DropdownMenuItem(
                                    value: value,
                                    child: LSSubtitle(text: value),
                                )).toList(),
                            ),
                            padding: EdgeInsets.only(right: 12.0),
                        ),
                    ),
                ),
                decoration: BoxDecoration(
                    color: LSColors.accent,
                ),
            ),
            _buildEntry(
                context: context,
                icon: CustomIcons.home,
                title: 'Home',
                route: '/',
            ),
            _buildEntry(
                context: context,
                icon: CustomIcons.settings,
                title: 'Settings',
                route: '/settings',
                justPush: true,
            ),
            LSDivider(),
            if(showIndexerSearch) _buildEntry(
                context: context,
                icon: Icons.search,
                title: 'Search',
                route: '/search',
            ),
            if(ModuleFlags.AUTOMATION && profile.anyAutomationEnabled) ExpansionTile(
                leading: Icon(CustomIcons.layers),
                title: Text('Automation'),
                initiallyExpanded: true,
                children: List.generate(
                    Database.currentProfileObject.enabledAutomationServices.length,
                    (index) => _buildEntry(
                        context: context,
                        route: Constants.SERVICE_MAP[Database.currentProfileObject.enabledAutomationServices[index]]['route'],
                        icon: Constants.SERVICE_MAP[Database.currentProfileObject.enabledAutomationServices[index]]['icon'],
                        title: Constants.SERVICE_MAP[Database.currentProfileObject.enabledAutomationServices[index]]['name'],
                        padLeft: true,
                    ),
                ),
            ),
            if(ModuleFlags.CLIENTS && profile.anyClientsEnabled) ExpansionTile(
                leading: Icon(CustomIcons.clients),
                title: Text('Clients'),
                initiallyExpanded: true,
                children: List.generate(
                    Database.currentProfileObject.enabledClientServices.length,
                    (index) => _buildEntry(
                        context: context,
                        route: Constants.SERVICE_MAP[Database.currentProfileObject.enabledClientServices[index]]['route'],
                        icon: Constants.SERVICE_MAP[Database.currentProfileObject.enabledClientServices[index]]['icon'],
                        title: Constants.SERVICE_MAP[Database.currentProfileObject.enabledClientServices[index]]['name'],
                        padLeft: true,
                    ),
                ),
            ),
        ];
    }

    Widget _buildEntry({
        @required BuildContext context,
        @required IconData icon,
        @required String title,
        @required String route,
        bool justPush = false,
        bool padLeft = false,
    }) {
        bool currentPage = page == title.toLowerCase();
        return ListTile(
            leading: LSIcon(
                icon: icon,
                color: currentPage ? LSColors.accent : Colors.white,
            ),
            title: Text(
                title,
                style: TextStyle(
                    color: currentPage ? LSColors.accent : Colors.white,
                ),
            ),
            onTap: () async {
                Navigator.of(context).pop();
                if(!currentPage) {
                    justPush
                        ? await Navigator.of(context).pushNamed(route)
                        : await Navigator.of(context).pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
                }
            },
            contentPadding: padLeft
                ? EdgeInsets.fromLTRB(42.0, 0.0, 0.0, 0.0)
                : EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
        );
    }
}