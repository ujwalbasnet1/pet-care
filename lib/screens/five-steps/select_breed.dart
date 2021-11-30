// import 'package:flutter/material.dart';
// import 'package:pets/DataModel/breed_model.dart';
// import 'package:pets/screens/five-steps/pet_details.dart';
// import 'package:pets/utils/app_utils.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
// import 'components/header.dart';
// import 'package:pets/theming/theme.dart';
// import 'package:pets/common/buttons/round_rectangle_button.dart';
// import 'components/custom_breed.dart';
// import 'package:pets/common/gradient_bg.dart';

// class SelectBreed extends StatefulWidget {
//   final petsInfo;
//   const SelectBreed({Key key, this.petsInfo}) : super(key: key);
//   @override
//   _AboutPetState createState() => _AboutPetState();
// }

// class _AboutPetState extends State<SelectBreed> {
//   var _selectedBreeds = "";
//   int currentSelectedIndex;

//   @override
//   Widget build(BuildContext context) {
//     return GradientBg(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Header(
//               currentPetNumber: 4,
//               title: "Select ${widget.petsInfo['name']}'s Breed",
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 10.0,
//               ),
//               margin: const EdgeInsets.all(
//                 padding,
//               ),
//               child: SearchableDropdown.single(
//                 underline: Container(),
//                 items: bree.map(
//                   (BreedModel value) {
//                     return new DropdownMenuItem<String>(
//                       value: value.breedName.toString(),
//                       child: new Text(
//                         value.breedName.toString(),
//                       ),
//                     );
//                   },
//                 ).toList(),
//                 // value: selectedReason,
//                 hint: "Select Breed",
//                 searchHint: null,
//                 onChanged: (value) {
//                   setState(() {
//                     // selectedReason = value;
//                     _selectedBreeds = value;
//                   });
//                 },
//                 dialogBox: true,
//                 isExpanded: true,
//                 menuConstraints: null,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: padding),
//               child: Text(
//                 "${widget.petsInfo['name']} Breed is $_selectedBreeds",
//                 style: Theme.of(context).textTheme.bodyText1.copyWith(
//                       fontSize: 16,
//                     ),
//               ),
//             ),
//             Spacer(),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: padding),
//               child: Wrap(
//                 children: [
//                   Text("Unable to find your breed?"),
//                   InkWell(
//                     onTap: () async {
//                       var data = await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return Dialog(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                               child: CustomBreed(
//                                 myContext: context,
//                               ),
//                             );
//                           });
//                       if (data != null) {
//                         breedModel
//                             .add(BreedModel(breedName: data['breed_name']));
//                         Future.delayed(Duration(seconds: 2))
//                             .then((value) => setState(() {
//                                   _selectedBreeds = data['breed_name'];
//                                 }));
//                       }
//                     },
//                     child: Text(
//                       " Add Custom Breed here",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             // SizedBox(
//             //   height: 100,
//             // ),
//             RoundRectangleButton(
//               title: "Next",
//               onPressed: () {
//                 if (_selectedBreeds.length > 2) {
//                   widget.petsInfo['breed'] = _selectedBreeds;
//                   openScreen(context, PetDetails(petsInfo: widget.petsInfo));
//                 } else {
//                   showToast("Select Breed", context);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
