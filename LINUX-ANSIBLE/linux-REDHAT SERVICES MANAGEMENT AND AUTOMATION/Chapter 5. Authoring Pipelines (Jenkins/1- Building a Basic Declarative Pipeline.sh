'The Jenkins Pipeline is a suite of plug-ins that extend the Jenkins core functionalities. This suite offers a way to define CI/CD pipelines 
into Jenkins. With the Pipeline suite enabled, you can create projects with the pipeline project type.'


A declarative pipeline is composed of blocks, sections, directives, steps, or assignment statements. The following section describes some of 
the most frequently used elements of a declarative pipeline.

Declarative pipelines must start with a pipeline block, and enclose the pipeline definition within this block. The following example 
illustrates the use of the pipeline block.

pipeline {
   agent ...output omitted...
   stages {
      ...output omitted...
   }
   post {
      ...output omitted...
   }
}





Declarative Pipeline Sections
A section is a segment of a pipeline script that contains one or more directives, or steps. The declarative syntax supports four different sections.

'agent'
The agent section defines conditions to select the machine or container that will execute the pipeline. For example, use agent
{ label { 'my_label' } } to declare that the pipeline must run on a Jenkins agent containing the my_label label. 
Other allowed keywords are any, none, node, or docker.

You can override the agent at a per stage level.

'stages'
The stages section defines one or more stages to execute in the pipeline. A stage is an aggregation of steps sharing a common purpose or 
configuration.

The stages section requires one or more stage directives: stages { stage { …​ } stage { …​ } }

'steps'
The steps section specifies a list of tasks to execute. The steps { echo 'Hello World' } section has a single echo task, which prints the 
message in the pipeline agent.

You can only use steps that are compatible with the Pipeline plug-in.

'post'
The post section defines additional tasks to execute upon the completion of a pipeline, or a stage. The execution of the tasks only occurs 
when conditions are met. Conditions are expressed with keywords such as always, failure, success, or cleanup. For example, you can use the 
post section to send a notification via chat or email when the pipeline fails. 
The following example highlights the sections involved in a minimal declarative pipeline.


pipeline {
   agent any 1
   stages { 2
      stage('Hello') {
         steps { 3
            echo 'Hello World!'
         }
      }
   }
}

1 Specifies that the pipeline should run on any available agent.

2 Defines the list of stages. This pipeline only has one stage, named Hello.

3 Defines the list of steps to execute in the Hello stage. The Hello stage only has the echo step.

-- > 'The pipeline block requires at least one agent, and one stages section.'

