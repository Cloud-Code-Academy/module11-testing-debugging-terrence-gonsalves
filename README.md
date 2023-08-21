# Developer Kickstart: Testing and Debugging
This project is an essential segment of the Developer Kickstart curriculum at Cloud Code Academy. Tailored specifically for up-and-coming Salesforce developers, this module plunges into the crucial aspects of testing and debugging, underscoring the necessity of robust test classes, effective debugging strategies, and the maintenance of high code coverage.

## Goals of the Practice
During this project, you will deepen your grasp of:

- The imperative role of test classes in ensuring the reliability and stability of your Apex code within Salesforce.
- Crafting and deploying well-structured test methods to cover a multitude of scenarios, both positive and negative.
- The importance of achieving and maintaining a high code coverage percentage, ensuring every line of code is vetted for functionality.
- Mastering Salesforce's built-in debugging tools, such as the Developer Console, to identify, diagnose, and resolve issues efficiently.
- Incorporating systematic logging and exception handling to provide clarity on runtime behaviors and unexpected errors.

By excelling in these testing and debugging techniques, you'll bolster your capability to write resilient and fault-tolerant code. This strengthens your expertise in ensuring that Salesforce applications are not only functional but also reliable, emphasizing the best practices that underpin top-tier Salesforce development.

## Setup
[Beginner Setup Overview Video](https://vimeo.com/839597882/46fc06d93e)

[Intermediate Setup Overview Video](https://vimeo.com/847130413/955b8bdbe2)

To get started, you'll need a Salesforce Trailhead Playground. If you don't have one, you can create it for free from any Trailhead module.

After you've set up your Trailhead Playground:

1. Install Visual Studio Code from [here](https://code.visualstudio.com/download).
2. Install Salesforce Extension Pack in Visual Studio Code. This can be done by searching 'Salesforce Extension Pack' in the Extensions view in VS Code and clicking Install.
3. Authorize your Trailhead Playground in Visual Studio Code. Press `Ctrl + Shift + P` to open the command palette and type 'SFDX: Authorize an Org', then press Enter. Follow the steps in the browser to log in to your Playground, then return to VS Code.
4. Deploy the Apex Class by right clicking on the `VariablesDatatypesOperators` and  `VariablesDatatypesOperatorsTest` file a using the option SFDX: Deploy Source to Org.

## Running the Test Classes

To run the test classes:

1. Open the command palette with `Ctrl + Shift + P`.
2. Type 'SFDX: Invoke Apex Tests...', and press Enter.
3. In the 'Select Test Class' input, select the test class you want to run and press Enter.
4. The test results will appear in the Output panel at the bottom of the screen. You can switch to the 'Test' tab in this panel to see a summary of the test run.

## Resources

If you get stuck at any point, here are some resources that might help:

- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dev_guide.htm)
- [Salesforce Stack Exchange](https://salesforce.stackexchange.com/)
- [Visual Studio Code Documentation](https://code.visualstudio.com/docs)
- [Salesforce Extensions for Visual Studio Code](https://developer.salesforce.com/tools/vscode/)

And remember, programming is often about solving problems, so don't be afraid to use search engines to find answers to your questions.

Good luck with your learning journey in Salesforce development!