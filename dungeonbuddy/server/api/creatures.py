from flask_restful import Resource

from flask_restful import request
from flask_restful import reqparse
import json
from .utils import *

class Vendo(Resource):
    def get(self):
        result = exec_get_all(""" SELECT item.name, item.price, buttons.button_label, vending_machine.quantity, vending_machine.row_number, vending_machine.position_number  FROM vending_machine JOIN item ON vending_machine.item_id = item.id JOIN buttons ON vending_machine.button_id = buttons.id ORDER BY  vending_machine.row_number ASC, vending_machine.position_number ASC""")
        return result
    
    def put(self):
        parser = reqparse.RequestParser()
        parser.add_argument('button_label')
        args = parser.parse_args()
        retrieval = "SELECT vending_machine.quantity, vending_machine.button_id FROM vending_machine JOIN buttons ON vending_machine.button_id = buttons.id WHERE button_label=%s"
        raw  = exec_get_one(retrieval, args['button_label'])
        quant = raw[0]
        butnum = raw[1]
        quant = quant-1
        sql = "UPDATE vending_machine SET quantity=%s WHERE button_id=%s"
        if (quant>0): 
            result = exec_commit(sql, (quant, butnum))
            return result
        else:
            result = exec_commit(sql, (raw[0], butnum))
            return result

    def post(self):   
        parser = reqparse.RequestParser()
        parser.add_argument('name')
        parser.add_argument('price')
        parser.add_argument('quantity')
        parser.add_argument('button_label')
        args = parser.parse_args()

        """Add it to the list of items"""
        toItems = "INSERT INTO item(name, price) VALUES(%s, %s)"
        exec_commit(toItems, (args['name'], args['price']))
        
        """Get the item.id back"""
        retrieval = "SELECT id FROM item WHERE name=%s"
        raw  = exec_get_one(retrieval, (args['name'],))
        itid = raw

        """Get the button.id back"""
        retrieval = "SELECT id FROM buttons WHERE button_label=%s"
        back  = exec_get_one(retrieval, args['button_label'])
        butid = back
        
        """Update the Vending Machine"""
        sql = "UPDATE vending_machine SET item_id=%s, quantity=%s WHERE button_id=%s"
        result  = exec_commit(sql,(itid, args['quantity'], butid))
