import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/constants/custom_field.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';
import 'package:spotify_clone_flutter/core/utils/loader.dart';
import 'package:spotify_clone_flutter/core/utils/utils.dart';
import 'package:spotify_clone_flutter/features/home/repositories/home_repository.dart';
import 'package:spotify_clone_flutter/features/home/view/pages/home_page.dart';
import 'package:spotify_clone_flutter/features/home/view/widgets/audio_wave.dart';
import 'package:spotify_clone_flutter/features/home/viewmodel/home_viewmodel.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  Future<void> selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  void removeAudio() {
    setState(() {
      selectedAudio = null;
    });
  }

  Future<void> selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  Future<void> changeAudio() async {
    removeAudio();
    selectAudio();
  }

  @override
  void dispose() {
    super.dispose();
    artistNameController.dispose();
    songNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewmodelProvider.select((val) => val?.isLoading == true),
    );
    ref.listen(homeViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, 'Upload Song Successfully');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(
            context,
            'Some error occured while uploading the song :  ${error.toString()}',
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: Icon(Icons.home, color: Colors.white),
        ),
        title: Text('Upload Song', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewmodelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedImage: selectedImage!,
                      songName: songNameController.text,
                      artist: artistNameController.text,
                      selectedColor: selectedColor,
                    );
                print('Request Completed Successfully');
              } else {
                showSnackBar(
                  context,
                  'Missing Field Please Check all field again',
                );
              }
            },
            icon: Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        onLongPress: removeImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                options: RectDottedBorderOptions(
                                  dashPattern: [10, 4],
                                  strokeWidth: 2,
                                  color: Pallete.borderColor,
                                ),
                                child: SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 50),
                                      SizedBox(height: 20),
                                      Text(
                                        'Select the Thumbnail for your song',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 20),

                      selectedAudio != null
                          ? AudioWave(
                              path: selectedAudio!.path,
                              color: selectedColor,
                            )
                          : CustomField(
                              hintText: 'Pick Song From Device',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),

                      selectedAudio != null
                          ? Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: removeAudio,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Pallete.transparentColor,
                                        shadowColor: Pallete.transparentColor,
                                      ),
                                      child: Text(
                                        'Remove Audio',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Pallete.gradient2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: changeAudio,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Pallete.transparentColor,
                                        shadowColor: Pallete.transparentColor,
                                      ),
                                      child: Text(
                                        'Change Audio',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Pallete.gradient2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),

                      SizedBox(height: 20),
                      CustomField(
                        hintText: 'Artist Name',
                        controller: artistNameController,
                      ),

                      SizedBox(height: 20),
                      CustomField(
                        hintText: 'Song Name',
                        controller: songNameController,
                      ),

                      ColorPicker(
                        pickersEnabled: {ColorPickerType.wheel: true},
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
