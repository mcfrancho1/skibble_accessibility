import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart';
import '../../controllers/create_edit_meets_controller.dart';
import '../../models/skibble_meet.dart';

class MeetSaveDeleteDraftView extends StatelessWidget {
  const MeetSaveDeleteDraftView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Leaving already?', style: TextStyle(color: kDarkSecondaryColor, fontWeight:  FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 10,),
          const Divider(),
          SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () async{
                    await context.read<CreateEditMeetsController>().saveMeetToDraft(context);

                    Navigator.pop(context);
                    if(Navigator.canPop(context))
                      Navigator.pop(context);
                  },
                  child: const Text('Save Draft'))),

          const Divider(),
          SizedBox(
            width: double.infinity,
            child: TextButton(onPressed: () async{

              context.read<CreateEditMeetsController>().reset(context);
              await context.read<CreateEditMeetsController>().resetDraft(context);

              Navigator.pop(context);
              if(Navigator.canPop(context))
                Navigator.pop(context);

            },
                child: const Text('Delete Draft', style: TextStyle(color: kErrorColor),)),
          ),
          Divider(),

          SizedBox(
              width: double.infinity,

              child: TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: kDarkSecondaryColor, ),)))
        ],
      ),
    );
  }
}
