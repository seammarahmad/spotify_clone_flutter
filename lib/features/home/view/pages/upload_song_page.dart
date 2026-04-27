import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_flutter/core/constants/custom_field.dart';
import 'package:spotify_clone_flutter/core/theme/app_pallete.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  @override
  Widget build(BuildContext context) {
    final songNameController = TextEditingController();
    final artistNameController = TextEditingController();
    var selectedColor=Pallete.cardColor;

    @override
    void dispose() {
      super.dispose();
      artistNameController.dispose();
      songNameController.dispose();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Upload Song')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              DottedBorder(
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
              SizedBox(height: 20),
              CustomField(
                hintText: 'Pick From Device',
                controller: null,
                readOnly: true,
                onTap: () {},
              ),
              SizedBox(height: 20),
              CustomField(
                hintText: 'Artist Name',
                controller: artistNameController,
              ),

              SizedBox(height: 20),
              CustomField(hintText: 'Song Name', controller: songNameController),

              ColorPicker(
                pickersEnabled: {
                  ColorPickerType.wheel: true,
                },
                  color: selectedColor,
                  onColorChanged: (Color color){
                setState(() {
                  selectedColor=color;
                });
              }),

            ],
          ),
        ),
      ),
    );
  }
}
