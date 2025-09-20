import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/widgets/dropdowns/city_paged_dropdown.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<StatefulWidget> createState() => _MyProfilState();
}

class _MyProfilState extends State<MyProfile> {
  late final _userProvider = GetIt.I<UserProvider>(param1: LoadingType.global);
  late final _cityProvider = GetIt.I<CityProvider>(param1: LoadingType.global);
  UserResponse? _userData;
  final _formKey = GlobalKey<FormState>();
  CityResponse? _userCity;

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _usernameController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initForm());
  }

  Future<void> _initForm() async {
    await _getUserInfo();
    _firstNameController = TextEditingController(text: _userData?.firstName);
    _lastNameController = TextEditingController(text: _userData?.lastName);
    _usernameController = TextEditingController(text: _userData?.username);
  }

  Future<void> _getUserInfo() async {
    var userId = await AccessTokenHandler.getUserId();
    _userData = await _userProvider.getById(userId);
    _userCity = await _cityProvider.getById(_userData!.cityId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: FormWrapper(formKey: _formKey, children: [..._buildForm(context)]),
      appBarTitle: const Text("Moj profil"),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    return [
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [Avatar(user: _userData, maxRadius: 90)],
          ),
          SizedBox(width: 50),
          Flexible(
            child: Column(
              children: [
                TextFormField(controller: _firstNameController),
                TextFormField(controller: _lastNameController),
                TextFormField(controller: _usernameController),
                SizedBox(height: 12),
                CityPagedDropdown(
                  onChanged: (value) => _userData?.cityId = value.id,
                  defaultItem: _userCity,
                  validator: (value) {
                    if (value == null) {
                      return "Grad je obavezan!";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}
