var AWS = require('aws-sdk');
var ec2 = new AWS.EC2({
    region: 'us-west-2'
    });
var rds = new AWS.RDS({
    region: 'us-west-2'
    });

var elbv2 = new AWS.ELBv2({
    region: 'us-west-2'
    });

    
//Get EC2 Instances
function getEC2Instances() {
    return new Promise((resolve) => {
            var EC2_instance_ids = []

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
                var EC2_instance_ids = []

                for(let i = 0; i < data.Reservations.length; i++){
                    for(let j = 0; j < data.Reservations[i].Instances.length; j++){
                        console.log("INSTANCE: " + data.Reservations[i].Instances[j].InstanceId);
                        EC2_instance_ids.push(data.Reservations[i].Instances[j].InstanceId);
                    }
                }
                resolve(EC2_instance_ids)
            });
        }, 10)
    })
}

//get RDS instances
function getRDSInstances() {
    return new Promise((resolve) => {
        setTimeout(() => {
            rds.describeDBInstances(function (err, data) {
                if (err) return console.error(err.message);
                var RDS_instance_ids = []

                for(let i = 0; i < data.DBInstances.length; i++){
                    //console.log("DATA: ", data.DBInstances[i]);
 //                   console.log("INSTANCEID: ", data.DBInstances[i].DBInstanceIdentifier);
                    var DBData = data.DBInstances[i].TagList;
//                    console.log("TAGLIST: ", data.DBInstances[i].TagList);
//                    console.log(DBData.find(({ Key }) => Key === 'Environment' ).Value)
//                    console.log(DBData.find(({ Key }) => Key === 'Created_By' ).Value)
                    if ((DBData.find(({ Key }) => Key === 'Environment' ).Value === 'Test') && (DBData.find(({ Key }) => Key === 'Created_By' ).Value === 'Terraform')) {
                        RDS_instance_ids.push(data.DBInstances[i].DBInstanceIdentifier);
                        console.log(RDS_instance_ids);
                    }
                }
                resolve(RDS_instance_ids)
            });
        }, 10)
    })
}

function delete_EC2_instance(instance_id){
    try{
        ec2.terminateInstances({ InstanceIds: [instance_id] }).promise()
        console.log("Terminating EC2 instance:" + instance_id)
    } catch (error) {
        console.error(error);
    };
}

function delete_RDS_instance(instance_id){
    try{
        rds.deleteDBInstance({ InstanceIds: [instance_id] }).promise()
        console.log("Terminating RDS instance:" + instance_id)
    } catch (error) {
        console.error(error);
    };
}

exports.handler = async function(event) {

    //https://www.seanmcp.com/articles/await-multiple-promises-in-javascript/
    //Slightly faster way than promise.all()
    const ec2Instances = getEC2Instances();
    const rdsInstances = getRDSInstances();

    await ec2Instances;
    await rdsInstances;

    if (ec2Instances.length != 0){
        for(let i = 0; i < ec2Instances.length; i++){                        
//            delete_EC2_instance(instanceIDS[i]);
        }
    }

    if (rdsInstances.length != 0){
        for(let i = 0; i < rdsInstances.length; i++){                        
//            delete_RDS_instance(instanceIDS[i]);
        }
    }
};