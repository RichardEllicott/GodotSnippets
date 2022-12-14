
class SQLiteWrapper:
    """extensive collection of simple wrappers for SQL commands"""

    def execute_sql(self, sql):
        """execute an sql string"""
        self.result = self.cursor.execute(sql)
        self.connection.commit()
        return self.result

    ## 
    def get_table_names(self): 
        """returns a list of table names, empty list if no tables"""

        # sql = "SELECT name FROM sqlite_master WHERE type='table';"
        # # sql = "tables"
        # self.cursor = self.connection.execute(sql)

        # cursor_description = self.cursor.description
        # if not cursor_description: cursor_description = [] ## if None is returned due to no tables, make it an empty list

        # names = list(map(lambda x: x[0], cursor_description)) ## convert the output to a plain list
        # names = cursor_description
        # return names

        sql = "SELECT name FROM sqlite_master WHERE type='table';"

        self.cursor = self.connection.cursor()
        self.cursor.execute(sql)
        ret = self.cursor.fetchall()
        ret = list(map(lambda x: x[0], ret))

        return ret


    def get_column_names(self, tablename):

        # https://www.alixaprodev.com/2022/03/python-to-get-database-column-names.html
        self.cursor = self.connection.execute('select * from {}'.format(tablename))
        names = list(map(lambda x: x[0], self.cursor.description)) ## convert the output to a plain list
        return names




    def does_table_exist(self, tablename):
        """does a tablename exist"""
        return tablename in self.get_table_names()

    def create_table(self, tablename, column_names):
        """create a table with columns, we assume strings only for our db, note will not overwrite an existing table will just return"""

        if self.does_table_exist(tablename):
            return

        self.column_names = column_names

        for cname in column_names:
            assert(cname.find(' ') == -1)

        vals = ", ".join(column_names)

        try:
            sql = "CREATE TABLE {}({})".format(tablename, vals)

            self.cursor.execute(sql)
            self.connection.commit()

        except Exception as e:
            print(e)
            print("EXCEPT HOOK")

    ## insert a row into a table, be sure to use a matching array or tuple with correct length, ie ['richard', 'pass123', 'some json data?'] based on the table's width
    def insert_row(self, tablename, row):
        """insert a row (as a list of tuple of correct length)"""
        self.insert_rows(tablename, [row])

    def insert_rows(self, tablename, rows):
        """insert a list of rows, could be a list of tuples, ensure the records are the correct length"""

        insert_width = len(rows[0])

        ## build a string like "?, ?, ?" for the sql "INSERT INTO table VALUES(?, ?, ?)"
        qmark_string = ''
        for i in range(insert_width):
            qmark_string += '?, '
        qmark_string = qmark_string[0:-2]

        # insert a list of rows
        sql = "INSERT INTO {} VALUES({})".format(tablename, qmark_string)

        self.cursor.executemany(sql, rows)
        # Remember to commit the transaction after executing INSERT.
        self.connection.commit()

    def get_all_rows(self, tablename):
        """get all rows as a list of tuples, this may be slow if table is large"""
        self.result = self.cursor.execute("SELECT * FROM {}".format(tablename))
        return self.result.fetchall()

    def _markdown_table_helper(self, _list, padding):
        """private class for printing a table to markdown"""

        new_list = []

        for i in range(len(_list)):
            val = "| " + str(_list[i])
            new_list.append(val.ljust(padding))

        new_list.append("|")

        s = "".join(new_list) + "\n"
        return s




    def get_markdown_table(self, tablename, padding):

        
        """

        | Syntax      | Description |
        | ----------- | ----------- |
        | Header      | Title       |
        | Paragraph   | Text        |

        """

        s = ""

        column_names = self.get_column_names(tablename)

        s += self._markdown_table_helper(column_names, padding)

        for i in range(len(column_names)):
            s += "| " + "-" * (padding - 3) + " "
        s += "|\n"


        rows = self.get_all_rows(tablename)

        for row in rows:

            s += "{}".format(self._markdown_table_helper(row, padding))



        return s


    def print_database(self):
        print("print_database...")

        print("tablenames: ", self.get_table_names())
        # print("tablenames: ", self.get_table_names())



        for tablename in self.get_table_names():



            print("tablename:", tablename)
            print("=" * 32)



    def print_table(self, tablename, padding = 32):

        print(self.get_markdown_table(tablename,padding))



    def delete_row(self, tablename, match_col, _id):

        sql = 'DELETE FROM {} WHERE {}=?'.format(tablename, match_col)

        self.cursor.execute(sql, (_id,))
        self.connection.commit()

    def delete_all_rows(self, tablename):
        # https://www.sqlitetutorial.net/sqlite-python/delete/

        sql = 'DELETE FROM {}'.format(tablename)
        self.cursor.execute(sql)
        self.connection.commit()

    def drop_table(self, tablename):
        sql = 'DROP TABLE {}'.format(tablename)
        try:
            self.cursor.execute(sql)
            self.connection.commit()
            return 0
        except Exception as e:
            # print("EXCEPTION ", e)
            return 1

    def __init__(self, filename):

        if isinstance(filename, str):
            filename = sqlite3.connect(filename)


        self.filename = filename
        self.connection = filename
        self.cursor = self.connection.cursor()


    def __del__(self):
        print("calls __del__...")
        self.connection.close()




        # NOT WORKING

    def get_rows(self, tablename, col = 'id', match = 'gordon'):
        sql = 'SELECT * FROM {} WHERE {}="{}";'.format(tablename, col, str(match))
        self.cursor.execute(sql)
        rows = self.cursor.fetchall()
        return rows

    def get_row(self, tablename, col = 'id', match = 'gordon'):
        sql = 'SELECT * FROM {} WHERE {}="{}";'.format(tablename, col, str(match))
        self.cursor.execute(sql)
        rows = self.cursor.fetchone()
        return rows

    def get_row_count(self, tablename):

        sql = "SELECT COUNT(*) FROM {}".format(tablename)
        self.result = self.cursor.execute(sql)
        return self.result.fetchone()[0]




    def get_row_by_id(self, tablename, _id):
        result = self.get_rows(tablename, 'id', _id)
        len_result = len(result)

        if len_result == 0: return None
        else: return result[0]


    def does_row_id_exist(self, tablename, _id):
        if self.get_row_by_id(tablename, _id) != None: return True # if result not None must be a match
        else: return False



    def update_cell(self, tablename, _id, col_name, data):
        ## https://www.sqlitetutorial.net/sqlite-replace-statement/

        ## https://stackoverflow.com/questions/22872814/how-do-i-update-values-in-an-sql-database-sqlite-python
        ## cursor.execute('''UPDATE books SET price = ? WHERE id = ?''', (newPrice, book_id))

        sql = 'UPDATE {} SET {} = ? WHERE id = ?'.format(tablename, col_name)
        self.result = self.cursor.execute(sql, (data, _id))
        self.connection.commit()

        def add_column(self, tablename, col_name):
            assert(False)

        def remove_column(self, tablename, col_name):
            assert(False)

    ## https://www.techonthenet.com/sqlite/tables/alter_table.php


    ## a table must have just two columns, id and data
    ## the id will be used as a key, the data column will have json saved in it

    def set_keyed_data(self, tablename, _id, data):

        data = json.dumps(data)
        if self.does_row_id_exist(tablename, _id): # if entry already exists update it
            self.update_cell(tablename, _id, 'data', data) ## only works if row is present
        else:
            self.insert_row(tablename, [_id, data]) # if not create new entry


    def get_keyed_data(self, tablename, _id):

        data = self.get_row_by_id(tablename, _id)
        if data != None:
            data = data[1]
            try:
                data = json.loads(data)
            except Exception as e:
                pass
        return data
