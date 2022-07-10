var AWS = require('aws-sdk');
var ec2 = new AWS.EC2({
    region: 'us-west-2'
    });
var RDS = new AWS.RDS({
    region: 'us-west-2'
    });

function getInstances() {
    return new Promise((resolve) => {
            var instance_ids = []

            var params = {
                Filters: [
                {
                Name: 'tag:Environment',
                Values: ['Test']
                },
                {
                Name: 'tag:Created_By',
                Values: ['Terraform']
                },
                {
                Name: 'instance-state-name',
                Values: ['running','stopped']
                }
                ] 
            };
        setTimeout(() => {
            ec2.describeInstances(params, function (err, data) {
                if (err) return console.error(err.message);
                var instance_ids = []

                for(let i = 0; i < data.Reservations.length; i++){
                    for(let j = 0; j < data.Reservations[i].Instances.length; j++){
                        console.log("INSTANCE: " + data.Reservations[i].Instances[j].InstanceId);
                        instance_ids.push(data.Reservations[i].Instances[j].InstanceId);
                    }
                }
                resolve(instance_ids)
            });
        }, 10)
    })
}

function delete_instance(instance_id){
    try{
        ec2.terminateInstances({ InstanceIds: [instance_id] }).promise()
        console.log("Terminating instance:" + instance_id)
    } catch (error) {
        console.error(error);
    };
}

exports.handler = async function(event) {
    //Redo this line
    //https://www.seanmcp.com/articles/await-multiple-promises-in-javascript/
    let instanceIDS = await getInstances();
    if (instanceIDS.length != 0){
        for(let i = 0; i < instanceIDS.length; i++){                        
            delete_instance(instanceIDS[i]);
        }
    }
};