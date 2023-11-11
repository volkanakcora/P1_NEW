'Creating Scripted Pipelines'

'Comparing Declarative and Scripted Pipelines'


Main differences between declarative and scripted pipelines:

'Declarative Pipelines	                                        Scripted Pipelines
'Follows a declarative programming model	                        Follows an imperative programming model
Simplified and opinionated syntax	                            Inherits the syntax from the Groovy language
Strict and predefined structure	                                Flexible structure
Ideal for continuous delivery pipelines	                        Ideal for advanced users with complex requirements


                                    'Writing a Scripted Pipeline'

Enclosing your pipeline definition within a node block. Jenkins will schedule the execution of the stages on a queue and create a 
dedicated workspace for the pipeline.

The following example illustrates the use of the node block, and the stage directive.

    node {
        stage('Hello') {
            echo 'Hello Ravi!'
        }
    }


Encapsulate subsets of steps with a common objective within stage directives.

Avoid complex steps by delegating execution to underlying frameworks.

For example, instead of creating a stage with multiple sh tasks, create a shell script aggregating all actions and use a single sh task 
invoking the script.

Just like declarative pipelines, you can only use steps that are compatible with the Pipeline plug-in. Some of the most used steps are echo, 
git, and sh.


                                    'Controlling the Flow'

String person = 'Zach' 1
def anotherPerson = 'Richard' 2
node {
    stage('Hello') {
        echo "Hello ${person} and ${anotherPerson}!" 3
    }
}


                                            'Conditionals'

Conditionals allow you to perform different actions depending on a boolean condition. For example, you can execute the build of your 
application only if the pipeline execution is in the main branch.

The following example shows the use of the standard if/else statement in a scripted pipeline.

node {
    stage('Hello') {
        if (env.BRANCH_NAME == 'main') {
            echo 'Hello Manuel!'
        } else {
            echo 'Hello Enol!'
        }
    }
}

'You can use other conditional statements in your pipeline scripts, for example the switch/case statement. Switch statements work like 
a set of chained if-statements. For long conditional chains, switch statements are often easier to read.'

                                                'Loops'

A loop is a structure that repeats a block of instructions until a condition is met. For example, you can store the name of your testing 
suites in a variable, loop through all the values, and execute the testing suites one after another.

One of the most common loop statements is for. The following example illustrates the standard use of the for statement.

def people = ['Eduardo', 'Jordi']
node {
    stage('Hello') {
        for (int i = 0; i < people.size(); ++i) {
            echo "Hello ${people[i]}!"
        }
    }
}


                                                    'Functions'

The following example illustrates the definition and usage of functions.

node {
    stage('Hello') {
        salute('Marek') 1
    }
}

def salute(person) { 2
    echo "Hello ${person}!"
}


                                                        'Combining Declarative and Scripted Pipelines'
                                                
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                script {
                    def people = ['Sam', 'Dave']
                    for (int i = 0; i < people.size(); ++i) {
                        echo "Hello ${people[i]}"
                    }
                }
            }
        }
    }
}


                            PGPASSWORD='TESTdev01xbsyt2spm' /usr/pgsql-14/bin/pg_dump -Fc -p 25207 -h xbintepdb1.deutsche-boerse.de  -U udev01xbsyt2spm   xbsyt2spm  | gzip > /tmp/xbsyt2spm.'${date}'.dump.gz
                            ls -alrt /tmp/xbsyt2spm.dump.gz

                            PGPASSWORD='TESTdev01xbsyt2rep' /usr/pgsql-14/bin/pg_dump -Fc -p 25207 -h xbintepdb1.deutsche-boerse.de  -U udev01xbsyt2rep   xbsyt2rep  | gzip > /tmp/xbsyt2rep.'${date}'.dump.gz
                            ls -alrt /tmp/xbsyt2rep.dump.gz


cp -p  /tmp/xbsyt2spm.dump.gz /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_inte/
cp -p  /tmp/xbsyt2rep.dump.gz /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_inte/



rm -f /tmp/xbsyt2spm.dump.gz
rm -f /tmp/xbsyt2rep.dump.gz



 PGPASSWORD='TESTdev01xbsyt2cor' /usr/pgsql-14/bin/pg_dump -Fc -p 25107 -h xbintepdb1.deutsche-boerse.de  -U udev01xbsyt2cor   xbsyt2cor  | gzip > /tmp/xbsyt2cor.'${date}'.dump.gz
                            ls -alrt /tmp/xbsyt2cor*.dump.gz



                           mkdir -p /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_inte/
                        EOF1
                        
                            cp -p  /tmp/'${components[i]}'*.dump.gz /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_inte/
                            cp -p  /tmp/xbsyt2cor*.dump.gz /net/energynfsdev.srv.energy/xbtestdbdump/dbdumps/xbid_inte/

                            

                            rm -f /tmp/'${components[i]}'*.dump.gz
                            rm -f /tmp/'xbsyt2cor*.dump.gz

























INSERT INTO tbxi035_config(id, version, config_key, party_id, config_value)
SELECT nextval('hibernate_sequence'), 0, 'SECONDARY_EMAIL_RECEIVER_ACTIVITY_REPORT_V2', '10XFR-RTE------Q', 'allocationDBS@services.rte-france.com' 
WHERE NOT EXISTS (
    SELECT 1 FROM tbxi035_config WHERE config_key = 'SECONDARY_EMAIL_RECEIVER_ACTIVITY_REPORT_V2' AND party_id = '10XFR-RTE------Q'
);





INSERT INTO tbxi035_config(id, version, config_key, party_id, config_value)
SELECT nextval('hibernate_sequence'), 0, 'SECONDARY_EMAIL_RECEIVER_ATC_VALUES_REPORT_V2', '10XFR-RTE------Q', 'allocationDBS@services.rte-france.com' 
WHERE NOT EXISTS (
    SELECT 1 FROM tbxi035_config WHERE config_key = 'SECONDARY_EMAIL_RECEIVER_ATC_VALUES_REPORT_V2' AND party_id = '10XFR-RTE------Q'
);


INSERT INTO tbxi035_config(id, version, config_key, party_id, config_value)
SELECT nextval('hibernate_sequence'), 0, 'SECONDARY_EMAIL_RECEIVER_ATC_VALUES_REPORT_V2', '10XCH-SWISSGRIDC', 'scheduling.day-ahead.fo@chtso.ch' 
WHERE NOT EXISTS (
    SELECT 1 FROM tbxi035_config WHERE config_key = 'SECONDARY_EMAIL_RECEIVER_ATC_VALUES_REPORT_V2' AND party_id = '10XCH-SWISSGRIDC'
);