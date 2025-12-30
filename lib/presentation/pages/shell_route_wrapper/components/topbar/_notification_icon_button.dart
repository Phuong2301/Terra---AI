part of '_topbar.dart';

class NotificationIconButton extends StatefulWidget {
  const NotificationIconButton({
    super.key,
    this.notificationCount = 0,
  });

  final int notificationCount;

  @override
  State<NotificationIconButton> createState() => _NotificationIconButtonState();
}

class _NotificationIconButtonState extends State<NotificationIconButton> {
  //final storage = StoreNotification.instance;

  @override
  void initState() {
    super.initState();
    iniFetch();
    fetchUserPermissions();
  }

  iniFetch() async {
    context.read<AppProvider>().fetchNotifications();
  }

  fetchUserPermissions() async {
    if (UserProvider.instance.permissions != null) return;
    UserProvider.instance.permissions = await AppAuth.fetchPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    return DropdownButton2(
      underline: const SizedBox.shrink(),
      customButton: _buildButton(context),
      dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
        width: responsiveValue<double>(
          context,
          xs: 380,
          md: 425,
        ),
        maxHeight: 425,
        offset: const Offset(0, -24),
        scrollbarTheme: _theme.scrollbarTheme.copyWith(
          thumbVisibility: WidgetStateProperty.all<bool>(false),
          trackVisibility: WidgetStateProperty.all<bool>(false),
        ),
      ),
      menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
        height: responsiveValue<double?>(
          context,
          xs: 75,
          lg: 80,
        ),
      ),
      items: context
          .read<AppProvider>()
          .notifications
          ?.map(
            (item) => DropdownMenuItem(
              value: item.id,
              child: NotificationTile(item: item),
            ),
          )
          .toList(),
      onChanged: (value) {
        final notiSelected = context
            .read<AppProvider>()
            .notifications!
            .firstWhere((e) => e.id == value);
        context.go(notiSelected.route);
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    final _theme = Theme.of(context);
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final _size = constraints.biggest;
        return SizedBox.square(
          dimension: _size.height / 2,
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.notifications_none_sharp,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                height: _size.height / 3.74,
                width: _size.height / 3.74,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    context.read<AppProvider>().notifications == null
                        ? '0'
                        : context
                            .read<AppProvider>()
                            .notifications!
                            .length
                            .toString(),
                    style: _theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: _theme.colorScheme.onError,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item});
  final MNotification item;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Row(
      children: [
        AvatarWidget(
          fullName: 'A C',
          initialsOnly: true,
          backgroundColor: _theme.colorScheme.primary.withOpacity(0.20),
          foregroundColor: _theme.colorScheme.primary,
          size: responsiveValue<Size?>(
            context,
            xs: const Size.square(38),
            lg: const Size.square(44),
          ),
        ),
        SizedBox(
          width: responsiveValue<double>(
            context,
            xs: 8,
            md: 12,
            lg: 16,
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(color: _theme.colorScheme.outline),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              title: Text(
                item.title, 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,),
              titleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.body, 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400
                  ),
                  ),
                  Text(
                    item.createdAt.convertToDate.convertDateTimeToString,
                    style: _theme.textTheme.labelSmall?.copyWith(
                      color: _theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
