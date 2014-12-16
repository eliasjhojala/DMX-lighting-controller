void inputSelected(File selection) {     if (selection != null) savePath = selection.getParent();        }
void outputSelected(File selection) {    if (selection != null) loadPath = selection.getParent();        }
void fileDialogInput() {                 selectInput("Select a file to process:", "inputSelected");      }
void fileDialogOutput() {                selectOutput("Select a file to write to:", "outputSelected");   }
