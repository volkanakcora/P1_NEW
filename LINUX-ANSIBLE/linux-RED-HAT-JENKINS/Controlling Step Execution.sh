'Creating Pipelines as Code'

Pipeline as code is a technique that encourages developers to treat the pipeline configuration as code. As with regular software code, 
you must track your pipeline configuration by using a version control system.


When you follow the pipeline as code technique, you usually keep the pipeline configuration in the same repository as the application code. 
The main advantages of this technique are the following:

  -  All the changes to the pipeline are trackable and auditable.

  -  The pipeline configuration is open and accessible to developers.


In Jenkins, you can follow this technique and store the pipeline script in a file, usually named Jenkinsfile. In this 
file you can use the declarative, or the scripted syntax to describe your pipeline.

pipeline {
    agent { node { label 'nodejs' } }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
    }
}

it defines the two stages involved in this pipeline. The first stage installs the dependencies and the second runs the tests. 



                                    'Controlling Step Execution'

Supplying Pipeline Parameters:

Jenkins allows you to parameterize your pipelines. This feature helps you to reuse your pipelines, or build more complex flows. 
A pipeline can declare parameters with values passed to the underlying tasks, parameters that decide the execution of some steps, 
or that restrict the agents that can execute the pipeline.



With the parameters directive you can define a list of parameters to use in the execution of the pipeline. In this list, 
you must define at least the type and a name for the parameter. Optionally, you can define a default value or a description.

The declarative syntax supports different types of parameters.

    string: to store strings.

    text: to store multiline strings.

    booleanParam: to store boolean values.

    choice: to store the value selected from a list of options.

    password: to stores credentials.


pipeline {
    agent any
    parameters {                                  1
        string(                                   2
            name: 'PERSON',                       3
            defaultValue: 'John'                  4
        )
    }
    stages {
        stage('Echo') {
            steps {
                echo "Hello ${params.PERSON}!"     5
            }
        }
    }
}


1 Initializes the definition of the pipeline parameters.

2 Defines the parameter type.

3 Defines the parameter name.

4 Sets the default value.

5 Uses the params object to access to the value of the PERSON parameter, and prints it.


                                                'Using Checkpoints'

In some cases, you might need to request confirmation from a user to execute a stage. For example, you might request confirmation before dropping a database 
or replacing a production application instance. Essentially, it is a good idea to ask for confirmation before any destructive task.

You must define at least the message option. Other configuration options are:

    'id': sets an optional identifier for the input.

    'submitter': defines a list of users allowed to submit the input.

    'ok': configures an alternative text for the approve button.

    'parameters': defines a list of parameters to prompt to the user to provide input. Those parameters are available in the environment only for the execution of the stage.

The following example describes a declarative pipeline that requests confirmation before the Echo stage is executed:

pipeline {
    agent any
    stages {
        stage('Echo') {
            input {                                 1
                message "Do you want to salute?"    2
            }
            steps {
                echo "Hello!"
            }
        }
    }
}

The preceding pipeline script defines:

1  The input directive.

2  The message to display to the user when the execution is paused.



                                                'Using Conditionals'

In more advanced pipelines, you might need to run a stage if certain conditions are met. It is common that some stages only run on selected code branches or environments. 
For example, executions on development branches avoid executing slow functional tests.


pipeline {
    agent any
    stages {
        stage('Echo') {
            when { 
                expression { env.GIT_BRANCH == 'origin/main' } 
            }
            steps {
                echo 'Hello from the main branch!'
            }
        }
    }
}

The preceding pipeline script defines:

1 The when directive.

2 The expression that determines when the stage is executed. In this case, the Echo stage is executed only in the origin/main branch.



!! The expression built-in condition evaluates instructions from the Groovy programming language. It only executes the stage if the 
result of evaluating the instruction is true. Keep in mind that strings evaluate to true and null evaluates to false.


#  !! The Groovy match operator (==~) allows to match a string against a regular expression. For example, "branch-test" ==~ /.*test/ will be matched as branch-test is a string ending by test.


                                                'Defining the Pipeline Execution'

Pipelines define a series of stages executed in a specific order. Jenkins supports three different types of stage executions: 
'sequential', 'parallel', and 'matrix'. In the same pipeline 

you can mix the three types of executions to adapt the pipeline to your needs.



    1 -The Checkout stage.

    2- The Install Dependencies stage.

    3 -The Test stage, executing the nested stages in sequential order.

        The stage named Suite A.

        The stage named Suite B.

You can transform the preceding flow into code by using the declarative syntax. The pipeline script for the preceding pipeline is the 
following:

pipeline {
    agent { node { label 'nodejs' } }
    stages {                                                            1
        stage('Install Dependencies) {
            steps { sh 'npm install' }
        }
        stage('Test') {
            stages {                                                    2
                stage('Suite A') {
                    steps { sh 'npm test -- -f testSuiteA' }
                }
                stage('Suite B') {
                    steps { sh 'npm test -- -f testSuiteB' }
                }
            }
        }
    }
}'

The preceding pipeline script defines:

1 A list of stages to execute in sequential order.

2 A list of nested stages to execute in sequential order.



                                                        'Parallel Execution'

In this type of execution, Jenkins executes all the stages included in the parallel section in parallel. Parallel 
execution of steps not only accelerates the execution of the pipeline but also enables a fail-fast approach on test-related steps.

n the preceding example, the execution order of the stages is:

    The Checkout stage.

    The Install Dependencies stage.

    The Test stage, executing the nested stages in parallel.

You can transform the preceding flow into code by using the declarative syntax. The pipeline script for the preceding pipeline is the following:

pipeline {
    agent { node { label 'nodejs' } }
    stages { 
        stage('Install Dependencies) {
            steps { sh 'npm install' }
        }
        stage('Test') {
            parallel { 
                stage('Suite A') {
                    steps { sh 'npm test -- -f testSuiteA' }
                }
                stage('Suite B') {
                    steps { sh 'npm test -- -f testSuiteB' }
                }
            }
        }
    }
}'


'Matrix Execution'

Sometimes a pipeline needs to execute the same steps multiple times with different combinations of parameters. Instead of declaring 
sequential or parallel stages for each combination, Jenkins can create the combinations by using matrix execution.

