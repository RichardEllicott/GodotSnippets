"""

FINALLY WORKS!!


now a minimal DB example



the db functions based on:
https://stackoverflow.com/questions/33535613/how-to-put-an-item-in-aws-dynamodb-using-aws-lambda-with-python


security permissions need to be enabled for this lambda to acess dynamodb:

https://aws.plainenglish.io/build-an-api-to-invoke-a-lambda-function-with-dynamodb-python-boto3-16d96be8cb2
"3. Create an IAM Role to permit Lambda to read & write the DynamoDB table"


"""
import boto3
import json
import hashlib
dynamodb = boto3.client('dynamodb')


## wrapper class
class DBTable:
    
    primary_key = 'id' ## name of the key column
    
    def _get(self, _id):
        request = dynamodb.get_item(TableName=self.tablename, Key={self.primary_key:{'S':_id}})
        # print("DB Request: ", request)
        return request

    def get_item(self, _id):
        return self._get(_id)['Item'] ## returns the row as a dict including id

    def put_item(self, item_dict): ## set the entire row from a dict including id
        dynamodb.put_item(TableName=self.tablename, Item=item_dict)
        
        
    # def update_item(self, item_dict): ## set the entire row from a dict including id
    #     dynamodb.update_item(TableName=self.tablename, Item=item_dict)
        
        
    
    ## https://github.com/aws-samples/aws-dynamodb-examples/tree/master/DynamoDB-SDK-Examples/python
        
        
    
    data_column_name = 'data' ## default data column for read/writing to
        



    ## functions to store data in a DB as a json string using a default column called 'data' (slow but easy)
    def get_string(self, _id):
        # item = dynamodb.get_item(TableName=self.tablename, Key={self.primary_key:{'S':_id}})['Item']
        item = self.get_item(_id)
        string = item[self.data_column_name]['S']
        return string
    
    
    def set_string(self, _id, string):
        ## this function will save a json string in a database, using only one column
        dynamodb.put_item(TableName=self.tablename, Item={self.primary_key:{'S':_id},self.data_column_name:{'S':string}})
        # self.put_item(_id, {self.primary_key:{'S':_id},self.data_column_name:{'S':string}})
        
    

    # ## functions to store data in a DB as a json string using a default column called 'data' (slow but easy)
    def json_get(self, _id):
        return json.loads(self.get_string(_id))
        
    def json_set(self, _id, data):
        self.set_string(_id, json.dumps(data))
        
        
        

    def __init__(self, tablename):
        self.tablename = tablename
    
    pass

    
    ## STRING ONLY SIMPLE DICT
    

    # get a simple dict, strings only
    def get_dict(self, _id):
        
        data = self.get_item(_id)
        item_dict = {}
        for key in data:
            val = data[key]
            if 'S' in val:
                val2 = val['S']
                item_dict[key] = val2
        return item_dict
    
    
    # set a simple dict, strings only
    def set_dict(self, _dict):
        
        item_dict = {}
        for key in _dict:
            val = _dict[key]
            
            item_dict[key] = {'S': val}
        
        self.put_item(item_dict)
        # dynamodb.update_item(TableName=self.tablename, Item=item_dict)
        
        
    ## rough and ready update function
    def update_by_dict(self, _id, _dict):
        copy = self.get_dict(_id)
        for key in _dict:
            copy[key] = _dict[key]
        self.set_dict(copy)
            
            
            
    def get_id_col(self, _id, col):
        ret = ""
        _dict = self.get_dict(_id)
        if col in _dict:
            ret = _dict[col]
        return str(ret)
    
    def set_id_col(self, _id, col, string):
        self.update_by_dict(_id, {self.primary_key : _id, col : string})
    
    
    ## creates an entry which will count
    def increment_column(self, _id, col = 'count'):
        
        _userdata = self.get_dict(_id)
        count = '0'
        if col in _userdata:
            count = _userdata[col]
        count = str(int(count) + 1)
        _userdata[col] = count
        
        self.set_dict(_userdata)
    

class Users:
    
    
    def list_users(self):
        
        pass
    
    
    
    def register_user(self, username, password):
        self.create_user(username,password)
    
    
    def create_user(self, username, password):

        
        userdata = {}
        sha256 = hashlib.sha256(password.encode('utf-8')).hexdigest()
        userdata['sha256'] = sha256
        
        userdata['password'] = password
        
        userdata['data'] = {'data1' : 'stuff123'}

        self.db.json_set(username, userdata)
        
        # return 'registered username: {} password: {} sucess!!!'.format(username, password)
        return True
        
    
        
    def authenticate_user(self, username, password):
        
        # userdata = self.get_user_data(username, password)
        # if not 'count' in userdata
        
        
        
        try:
            userdata = self.db.json_get(username)
            sha256 = hashlib.sha256(password.encode('utf-8')).hexdigest()
            assert(sha256 == userdata['sha256'])
            
            
            
            
        except:
            return False
        return True
        
        
        
        
    def get_user_data(self, username, password):
        assert(self.authenticate_user(username, password))
        return self.db.json_get(username)
        
        
        
    def set_user_data(self, username, password, new_data):
        
        userdata = self.get_user_data(username, password)
        
        data = userdata['data']
        
        for key in new_data:
            val = new_data[key]
            data[key] = val
            
        
        userdata['data'] = data
        
        self.db.json_set(username)
        
        
        
        
        pass
        
        
        

        
        
    
    
    def __init__(self, tablename):
        self.tablename = tablename
        self.db = DBTable(tablename)
    


## database wrapper, everything must be a string
class DBTable2:
    
    
    primary_key = 'id' ## name of the key column
    
    def __init__(self, tablename):
        self.tablename = tablename
        
    
    def _get(self, _id): ## the complete request
        return dynamodb.get_item(TableName=self.tablename, Key={self.primary_key: {'S': _id}})

    def _get_item(self, _id): ## returns the item in typed format: {'id': {'S': 'richard'}, 'password': {'S': '1234'}}
        return self._get(_id)['Item'] 

    def _put_item(self, item_dict): ## set the entire row from a dict including id
        dynamodb.put_item(TableName=self.tablename, Item=item_dict)
        
        
    
    dict_cache = {}
    # get a simple dict, strings only
    def get_dict(self, _id):
        
        if not _id in self.dict_cache:
            
            data = self._get_item(_id)
            item_dict = {}
            for key in data:
                val = data[key]
                # if 'S' in val:
                val2 = val['S']
                item_dict[key] = val2
                
            self.dict_cache[_id] = item_dict
            
        return self.dict_cache[_id]
    
    
    def delete_item(self, _id):
        
        ## good docs
        ## https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html#DynamoDB.Client.delete_item
        
        dynamodb.delete_item(TableName=self.tablename, Key={'id' : {'S' : _id}})
        
        
        pass
    
    # set a simple dict, strings only
    def set_dict(self, _dict):
        
        _id = _dict[self.primary_key] ## we must have a primary key
        
        item_dict = {}
        for key in _dict:
            val = _dict[key]
            
            item_dict[key] = {'S': val}
        
        self._put_item(item_dict) ## works, but no update
        
        
        
        
        update_dict = {"Genre777": {
            "Action": "PUT", 
            "Value": {"S":"Rock"}
        }}
        
        
        
        ## to use this we need to build a dict:
        ## https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/LegacyConditionalParameters.AttributeUpdates.html
        
        # dynamodb.update_item(
        #     Key = {'id', _id},
        #     TableName = self.tablename,
        #     AttributeValues = update_dict)
        
        # dynamodb.update_item(Key=_id, TableName=self.tablename, AttributeUpdates=item_dict) ## seems to work if record already exists
        
        ## https://stackoverflow.com/questions/34447304/example-of-update-item-in-dynamodb-boto3
        
        
        
        
        
        
        # response = dynamodb.update_item(
        #     TableName=self.tablename,
        #     # Key={'id': 'richard222'},
        #     Key={'id': {'S' : 'richard222'}},
            
            
        #     UpdateExpression='SET',
        #     # ConditionExpression='Attr(\'ReleaseNumber\').eq(\'1.0.179\')',
        #     ExpressionAttributeNames={'attr1': 'val1'},
        #     ExpressionAttributeValues={'val1': {'S' : 'testststs'}}
        # )
        
        
        
        
        
        
        
        # self.dict_cache[_id] = item_dict ## cache
        
        
        


server = Users('d-mole')


def test():
    print("test...")
    response = "RETURN FROM TEST COMMAND 123!!!\n"
    
    db = DBTable2('d-mole')
    
    
    
    test_id = 'richard222'
    
    print(db.set_dict({'id': test_id, 'root': 'aaa'}))
    
    
    print("get_item: ", db._get_item(test_id))
    
    

    ## DELETE EXAMPLE... needs the keytype syntax
    dynamodb.delete_item(TableName='d-mole', Key={'id' : {'S' : 'richard222'}}) ## I THINK WORKS!!

    
    # db.set_id_col(test_id,'haha', 'haha123')
    
    
    # _userdata = db.get_dict('richard')
    # count = '0'
    # if 'count' in _userdata:
    #     count = _userdata['count']
    # count = str(int(count) + 1)
    # _userdata['count'] = count
    
    # db.set_dict(_userdata)
    
    # print(_userdata)
    
    
    # db.increment_column(test_id,'requests')
    # print()
    
    
    print("DICT ********")
    _dict = db.get_dict(test_id)
    for key in _dict:
        val = _dict[key]
        print("    {}: {}".format(key, val))
    
    print("DICT ********")

    
    
    
    return response
    
    pass


def handle_event(event_dict):
    
    response = "NO RESPONSE!"
    
    
    # command = event_dict['command']
    # username = event_dict['username']
    # password = event_dict['password']
    
    
    command = event_dict.get('command')
    username = event_dict.get('username')
    password = event_dict.get('password')
    
    
    data = event_dict.get('data')
    
    
    if command == 'test':
        response = test()
        pass
    
    elif command == 'authenticate':
        response = server.authenticate_user(username, password)
        
    elif command == 'register':
        response = server.register_user(username, password)
        
        
        
    elif command == 'get_user_data':
        response = server.get_user_data(username, password)
        
    
        
    elif command == 'set_user_data':
        response = server.set_user_data(username, password, data)

    
        
    return response


    


def lambda_handler(event, context):
    
    # event_dict = 
    
        # body = event['body'] ## will be a json string (this is what we should be sending to the rest)
    # _dict = json.loads(event) ## should become a dictionary
    
    # handle_event(event['body'])
    
    
    response = "server responded, but no command result!"
    
    # try:
    print(event)
    
    event = event['body']
    event = json.loads(event)
    response = handle_event(event)
    # except Exception as e:
    #     response = str(e)
    
    
    
    # ## REGISTER
    # response = handle_event({
    #     'command' : 'register',
    #     'username' : 'bob33',
    #     'password' : '1234'
    # })
    
    # ## AUTHORISE
    # response = handle_event({
    #     'command' : 'authenticate',
    #     'username' : 'bob33',
    #     'password' : '12345'
    # })
    
    
    
    
    # response = handle_event(event)
    
    

    
    print("****" * 8)
    print("****" * 8)


    
    # users = Users('db_mole_users')
    # print(users.register_user('bob', '1234'))
    # print(users.authenticate_user('bob2', '1234'))

    
    


    print("****" * 8)
    print("****" * 8)

    

    
    
    
    
    return {
            'statusCode': 200,
            'body': json.dumps(response)
        }    
    







