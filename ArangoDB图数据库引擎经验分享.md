# ArangoDB图数据库引擎经验分享

## 1.[Arango简介](https://www.arangodb.com/docs/stable/)  

ArangoDB文档结构及参考场景  

### 1.1.[AramgoDB定位](https://www.arangodb.com)  

![][2]   

![][1]  

![][3]  

### 1.2.Manual  

- 基本概念  
- 功能描述  
- 安装配置  
- 其他相关内容  
  

使用场景：  
安装及配置时可根据此文档做参考。  

### 1.3.AQL  

Arango查询语言。查询语法相关内容。  
开发过程中，根据接口要求写AQL执行查询时参考。  

实用章节: [Usual Query Patterns][4]  

### 1.4.HTTP  

通过REST API 提供使用以及管理等操作，功能全面。  
应用场景:   
类DDL: Collection 新建，删除，计数，管理SearchView、Graph等相关对象  
类DML:Truncate，批量导入(upsert)  

### 1.5.Drivers  

提供多种语言驱动，类似JDBC。  
应用场景: 在代码中执行AQL查询。  

## 2.QuickStart  

### 2.1.安装运行  

```bash  
  
#!/usr/bin/env bash  
  
# make host directories  
mkdir -p ~/data/arangodb  
  
docker run -d \  
    -e ARANGO_NO_AUTH=1 \  
    -p 8529:8529 \  
    --name arangodb-instance \  
    -v ~/data/arangodb/data:/var/lib/arangodb3   
    arangodb  
  
  
# 企业版：  
docker run -d -p 8529:8529 \   
    -e ARANGO_NO_AUTH=1 \  
    -e ARANGO_LICENSE_KEY=EVALUATION:125f16ada6047bd17eeeefa3f011070510b5fbd9d85122afdeca72c380e7ac83 \  
    --name arangodb-ee \  
    -v ~/data/arangodb/data:/var/lib/arangodb3 \  
    arangodb/enterprise:3.4.7  
  
# Ctrl + P + Q  
```
[Run ArangoDB Enterprise Edition with Docker](https://www.arangodb.com/download-arangodb-enterprise/install-enterprise/docker_/)  

### 2.2.WebUI  

### 2.3.数据模型  

* database  
* collection  
    * document  
        * _id  
        * _key  
    * edge  
        * _id  
        * _key  
        * _from  
        * _to  
* view  
      
    ![][5]  
  
* graph  
      
    [Graphs][6]  
  
    * vertex  
    * edge  
    * path  

### 2.4.AQL示例  

[AQL tutorial][7]  

* CURD  
    * **[<u>Create documents][8]**</u>  
          
        语法：  
        ```sql  
        INSERT document INTO collectionName  
        ```
        用例：  
        
        ```sql  
        新建Characters  
        INSERT {  
            "name": "Ned",  
            "surname": "Stark",  
            "alive": true,  
            "age": 41,  
            "traits": ["A","H","C","N","P"]  
        } INTO Characters  
        ```
        
        多个导入：  
        ```sql  
        LET data = []  
        FOR d IN data  
            INSERT d INTO Characters  
        ```
        用例：  
        ```sql  
        LET data = [  
            { "name": "Robert", "surname": "Baratheon", "alive": false, "traits": ["A","H","C"] },  
            { "name": "Jaime", "surname": "Lannister", "alive": true, "age": 36, "traits": ["A","F","B"] },  
            { "name": "Catelyn", "surname": "Stark", "alive": false, "age": 40, "traits": ["D","H","C"] },  
            { "name": "Cersei", "surname": "Lannister", "alive": true, "age": 36, "traits": ["H","E","F"] },  
            { "name": "Daenerys", "surname": "Targaryen", "alive": true, "age": 16, "traits": ["D","H","C"] },  
            { "name": "Jorah", "surname": "Mormont", "alive": false, "traits": ["A","B","C","F"] },  
            { "name": "Petyr", "surname": "Baelish", "alive": false, "traits": ["E","G","F"] },  
            { "name": "Viserys", "surname": "Targaryen", "alive": false, "traits": ["O","L","N"] },  
            { "name": "Jon", "surname": "Snow", "alive": true, "age": 16, "traits": ["A","B","C","F"] },  
            { "name": "Sansa", "surname": "Stark", "alive": true, "age": 13, "traits": ["D","I","J"] },  
            { "name": "Arya", "surname": "Stark", "alive": true, "age": 11, "traits": ["C","K","L"] },  
            { "name": "Robb", "surname": "Stark", "alive": false, "traits": ["A","B","C","K"] },  
            { "name": "Theon", "surname": "Greyjoy", "alive": true, "age": 16, "traits": ["E","R","K"] },  
            { "name": "Bran", "surname": "Stark", "alive": true, "age": 10, "traits": ["L","J"] },  
            { "name": "Joffrey", "surname": "Baratheon", "alive": false, "age": 19, "traits": ["I","L","O"] },  
            { "name": "Sandor", "surname": "Clegane", "alive": true, "traits": ["A","P","K","F"] },  
            { "name": "Tyrion", "surname": "Lannister", "alive": true, "age": 32, "traits": ["F","K","M","N"] },  
            { "name": "Khal", "surname": "Drogo", "alive": false, "traits": ["A","C","O","P"] },  
            { "name": "Tywin", "surname": "Lannister", "alive": false, "traits": ["O","M","H","F"] },  
            { "name": "Davos", "surname": "Seaworth", "alive": true, "age": 49, "traits": ["C","K","P","F"] },  
            { "name": "Samwell", "surname": "Tarly", "alive": true, "age": 17, "traits": ["C","L","I"] },  
            { "name": "Stannis", "surname": "Baratheon", "alive": false, "traits": ["H","O","P","M"] },  
            { "name": "Melisandre", "alive": true, "traits": ["G","E","H"] },  
            { "name": "Margaery", "surname": "Tyrell", "alive": false, "traits": ["M","D","B"] },  
            { "name": "Jeor", "surname": "Mormont", "alive": false, "traits": ["C","H","M","P"] },  
            { "name": "Bronn", "alive": true, "traits": ["K","E","C"] },  
            { "name": "Varys", "alive": true, "traits": ["M","F","N","E"] },  
            { "name": "Shae", "alive": false, "traits": ["M","D","G"] },  
            { "name": "Talisa", "surname": "Maegyr", "alive": false, "traits": ["D","C","B"] },  
            { "name": "Gendry", "alive": false, "traits": ["K","C","A"] },  
            { "name": "Ygritte", "alive": false, "traits": ["A","P","K"] },  
            { "name": "Tormund", "surname": "Giantsbane", "alive": true, "traits": ["C","P","A","I"] },  
            { "name": "Gilly", "alive": true, "traits": ["L","J"] },  
            { "name": "Brienne", "surname": "Tarth", "alive": true, "age": 32, "traits": ["P","C","A","K"] },  
            { "name": "Ramsay", "surname": "Bolton", "alive": true, "traits": ["E","O","G","A"] },  
            { "name": "Ellaria", "surname": "Sand", "alive": true, "traits": ["P","O","A","E"] },  
            { "name": "Daario", "surname": "Naharis", "alive": true, "traits": ["K","P","A"] },  
            { "name": "Missandei", "alive": true, "traits": ["D","L","C","M"] },  
            { "name": "Tommen", "surname": "Baratheon", "alive": true, "traits": ["I","L","B"] },  
            { "name": "Jaqen", "surname": "H'ghar", "alive": true, "traits": ["H","F","K"] },  
            { "name": "Roose", "surname": "Bolton", "alive": true, "traits": ["H","E","F","A"] },  
            { "name": "The High Sparrow", "alive": true, "traits": ["H","M","F","O"] }  
        ]  
        FOR d IN data  
            INSERT d INTO Characters  
        ```
    
    * **[<u>Read documents][9]**</u>  
          
        遍历：  
        ```sql  
        FOR c IN Characters  
            RETURN c  
        ```
        
        指定：  
        ```sql  
        RETURN Document('Characters/1986')  
        RETURN DOCUMENT("Characters", "1986")  
        RETURN DOCUMENT("Characters", ["1986", "2039"])  
        ```
    
    * **[<u>Update documents][10]**</u>  
          
        语法：  
        
        ```sql  
          
        UPDATE/REPLACE documentKey WITH object IN collectionName  
          
          
        ```
        
        用例：   
        ```sql  
        更新(PATCH)  
        UPDATE "1986" WITH { alive: false } IN Characters  
        替换(PUT)  
        REPLACE "1986" WITH {  
            name: "Ned",  
            surname: "Stark",  
            alive: false,  
            age: 41,  
            traits: ["A","H","C","N","P"]  
        } IN Characters  
          
        遍历更新  
        FOR c IN Characters  
            UPDATE c WITH { season: 1 } IN Characters  
        ```
    
    * **[<u>Delete documents][11]**</u>  
          
        语法：  
        
        ```sql  
        REMOVE _key IN Characters  
        ```
        
        用例：  
        
        ```sql  
        REMOVE "2861650" IN Characters  
        ```
  
* Graph  
    * 关系及数据准备  
          
        人物关系：  
         ![][13]   
        
        新建Collections   
         ![][12]   
        
        数据写入  
        ```sql  
        LET data = [  
            {  
                "parent": { "name": "Ned", "surname": "Stark" },  
                "child": { "name": "Robb", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Ned", "surname": "Stark" },  
                "child": { "name": "Sansa", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Ned", "surname": "Stark" },  
                "child": { "name": "Arya", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Ned", "surname": "Stark" },  
                "child": { "name": "Bran", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Catelyn", "surname": "Stark" },  
                "child": { "name": "Robb", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Catelyn", "surname": "Stark" },  
                "child": { "name": "Sansa", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Catelyn", "surname": "Stark" },  
                "child": { "name": "Arya", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Catelyn", "surname": "Stark" },  
                "child": { "name": "Bran", "surname": "Stark" }  
            }, {  
                "parent": { "name": "Ned", "surname": "Stark" },  
                "child": { "name": "Jon", "surname": "Snow" }  
            }, {  
                "parent": { "name": "Tywin", "surname": "Lannister" },  
                "child": { "name": "Jaime", "surname": "Lannister" }  
            }, {  
                "parent": { "name": "Tywin", "surname": "Lannister" },  
                "child": { "name": "Cersei", "surname": "Lannister" }  
            }, {  
                "parent": { "name": "Tywin", "surname": "Lannister" },  
                "child": { "name": "Tyrion", "surname": "Lannister" }  
            }, {  
                "parent": { "name": "Cersei", "surname": "Lannister" },  
                "child": { "name": "Joffrey", "surname": "Baratheon" }  
            }, {  
                "parent": { "name": "Jaime", "surname": "Lannister" },  
                "child": { "name": "Joffrey", "surname": "Baratheon" }  
            }  
        ]  
          
        FOR rel in data  
            LET parentId = FIRST(  
                FOR c IN Characters  
                    FILTER c.name == rel.parent.name  
                    FILTER c.surname == rel.parent.surname  
                    LIMIT 1  
                    RETURN c._id  
            )  
            LET childId = FIRST(  
                FOR c IN Characters  
                    FILTER c.name == rel.child.name  
                    FILTER c.surname == rel.child.surname  
                    LIMIT 1  
                    RETURN c._id  
            )  
            FILTER parentId != null AND childId != null  
            INSERT { _from: childId, _to: parentId } INTO ChildOf  
            RETURN NEW  
        ```
    
    *  [Traversals语法][14]  
          
        **Working with collection sets**  
        ```sql  
        [WITH vertexCollection1[, vertexCollection2[, ...vertexCollectionN]]]  
        FOR vertex[, edge[, path]]  
          IN [min[..max]]  
          OUTBOUND|INBOUND|ANY startVertex  
          edgeCollection1, ..., edgeCollectionN  
          [PRUNE pruneCondition]  
          [OPTIONS options]  
        ```
        
        
        **Working with named graphs**   
        ```sql  
        [WITH vertexCollection1[, vertexCollection2[, ...vertexCollectionN]]]  
        FOR vertex[, edge[, path]]  
          IN [min[..max]]  
          OUTBOUND|INBOUND|ANY startVertex  
          GRAPH graphName  
          [PRUNE pruneCondition]  
          [OPTIONS options]  
        ```
    
    * 用例（匿名图）  
          
        场景一： 子 --> 父  
        
        ```sql  
        获取Bran的id  
        FOR c IN Characters  
            FILTER c.name == "Bran"  
            RETURN c._id  
        获取父节点  
        FOR v IN 1..1 OUTBOUND "Characters/2052" ChildOf  
            RETURN v.name  
          
        Bran --> 父节点  
        FOR bran IN Characters  
            FILTER bran.name == "Bran"  
            FOR v IN 1..1 OUTBOUND bran ChildOf  
                RETURN v.name  
        ```
        
        
        场景二： 父 --> 子  
        ```sql  
        FOR c IN Characters  
            FILTER c.name == "Ned"  
            FOR v IN 1..1 INBOUND c ChildOf  
                RETURN v.name  
        ```
        
        
        场景三： 祖 --> 孙  
        ```sql  
        FOR c IN Characters  
            FILTER c.name == "Tywin"  
            FOR v IN 2..2 INBOUND c ChildOf  
                RETURN DISTINCT v.name  
        ```
        
        
        遍历深度：min..max  
         ![][15]   
        
        ```sql  
        FOR c IN Characters  
            FILTER c.name == "Tywin"  
            FOR v IN 0..2 INBOUND c ChildOf  
                RETURN DISTINCT v.name  
        ```
    
    * 图用例  
          
        **Working with named graphs**   
        ```sql  
        [WITH vertexCollection1[, vertexCollection2[, ...vertexCollectionN]]]  
        FOR vertex[, edge[, path]]  
          IN [min[..max]]  
          OUTBOUND|INBOUND|ANY startVertex  
          GRAPH graphName  
          [PRUNE pruneCondition]  
          [OPTIONS options]  
        ```
        
        用例：  
        ```  
        FOR c IN Characters  
            FILTER c.name == "Tywin"  
            FOR v IN ANY c GRAPH "GOT"  
                return v.name  
        ```

### 2.5.GraphCourse  

附件: [6.GraphCourse.pdf][16]  

## 3.Mysql+NiFi+Arango实战  

### 3.1.数据准备  

mysql数据库：  
```bash  
mkdir -p ~/data/mysql  
  
docker run -v ~/data/mysql:/var/lib/mysql \  
    --name mysql5.7.24 \  
    -p3306:3306 \  
    -e MYSQL_ROOT_PASSWORD=123456@ \  
    -d mysql:5.7.24  
```


Northwind DDL+DML：[附件Northwind.MySQL5.sql][17]  

### 3.2.Arango Collection  

```json  
[  
  {"name": "ProductSupplier", "status": 3, "type": 3},  
  {"name": "OrderProduct", "status": 3, "type": 3},  
  {"name": "OrderEmployee", "status": 3, "type": 3},  
  {"name": "TerritoryRegion", "status": 3, "type": 3},  
  {"name": "ProductCategory", "status": 3, "type": 3},  
  {"name": "EmployeeTerritory", "status": 3, "type": 3},  
  {"name": "OrderShipper", "status": 3, "type": 3},  
  {"name": "Categories", "status": 3, "type": 2},  
  {"name": "Customers", "status": 3, "type": 2},  
  {"name": "Employees", "status": 3, "type": 2},  
  {"name": "Orders", "status": 3, "type": 2},  
  {"name": "OrderCustomer", "status": 3, "type": 3},  
  {"name": "Products", "status": 3, "type": 2},  
  {"name": "ReportTo", "status": 3, "type": 3},  
  {"name": "Region", "status": 3, "type": 2},  
  {"name": "Shippers", "status": 3, "type": 2},  
  {"name": "Suppliers", "status": 3, "type": 2},  
  {"name": "Territories", "status": 3, "type": 2}  
]  
```

### 3.3.NiFi  

* DataModeling.sql  
    附件: [DataModeling_V_E.sql][18]  
  
* arango-northwind.xml  
    附件: [arango-northwind.xml][19]  
    
    ![][20]  
    
    
    ![][21]  
    
    ![][22]  

### 3.4.ArangoSearchView  

* 场景  
      
    输入任意字符串，获取所有与该字符串相匹配的节点信息  
    
    ```  
    For v in  ${Collections ...}  
     filter STARTS_WITH(v._search, 'An')  
     return v  
      
    ```
    问题一： AQL无法支持同时指定多个collection  
    问题二： Filter 子句无法支持`Start_with`算子  
    ![][23]  
  
* 定义  
      
    ```json  
      
    // PUT {{arangodb_ip}}/_db/:database/_api/view/:view-name/properties  
    {  
      "links": {  
        "Suppliers": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Categories": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Products": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Orders": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Shippers": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Customers": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Employees": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Territories": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}},  
        "Region": {"fields": {"_key": {}, "_id": {}, "_type": {}, "_search": {}}}  
      }  
    }  
      
    ```
    
    ![][24]  
  
* 用法  
      
    前缀匹配：  
    ```  
    For v in northwind_view   
     search STARTS_WITH(v._search, 'An')  
     return v  
    ```
    [ ArangoSearch Views Usage][26]  
    
    ![][25]  

### 3.5.ArangoGraph  

* 场景  
      
    指定任意起点，获取所有与该起点有关联的节点  
    ```sql  
    for v,e,p in any ${startVertex} ${edges ...}  
    return v,e,p  
      
    ```
    
    
    **Working with collection sets**  
    ```sql  
    [WITH vertexCollection1[, vertexCollection2[, ...vertexCollectionN]]]  
    FOR vertex[, edge[, path]]  
      IN [min[..max]]  
      OUTBOUND|INBOUND|ANY startVertex  
      edgeCollection1, ..., edgeCollectionN  
      [PRUNE pruneCondition]  
      [OPTIONS options]  
    ```
    
    不定义Named Graph也能满足。但是调用方需要维护vertexCollection及其关联的edgeCollection，  
    并在调用查询时，传入edgeCollection。  
    
    目标：  
    ```sql  
    for v,e,p in any ${startVertex} ${graph}  
    return v,e,p  
    ```
    调用方只需要传入起点即可获取所有相关连的edge及targetVertex  
  
* 定义  
      
    ```json  
      
    {  
        "_key": "northwind",  
        "numberOfShards": 1,  
        "replicationFactor": 1,  
        "isSmart": false,  
        "edgeDefinitions": [  
          {"collection": "ProductSupplier", "from": ["Products"], "to": ["Suppliers"]},  
          {"collection": "OrderProduct", "from": ["Orders"], "to": ["Products"]},  
          {"collection": "OrderEmployee", "from": ["Orders"], "to": ["Employees"]},  
          {"collection": "TerritoryRegion", "from": ["Territories"], "to": ["Region"]},  
          {"collection": "ProductCategory", "from": ["Products"], "to": ["Categories"]},  
          {"collection": "EmployeeTerritory", "from": ["Employees"], "to": ["Territories"]},  
          {"collection": "OrderShipper", "from": ["Orders"], "to": ["Shippers"]},  
          {"collection": "OrderCustomer", "from": ["Orders"], "to": ["Customers"]},  
          {"collection": "ReportTo", "from": ["Employees"], "to": ["Employees"]}  
        ],  
        "orphanCollections": [],  
        "_rev": "_Y7-SQHO---",  
        "name": "northwind"  
      }  
      
    ```
    
    ![][27]  
    ![][28]  
  
* 用法  
      
    [Traversals][29]  

[1]: assets/rgb.png
[2]: assets/puk.png
[3]: assets/qgb.png
[4]: https://www.arangodb.com/docs/stable/aql/examples.html
[5]: assets/crj.png
[6]: https://www.arangodb.com/docs/stable/graphs.html
[7]: https://www.arangodb.com/docs/stable/aql/tutorial.html
[8]: https://www.arangodb.com/docs/stable/aql/tutorial-crud.html#create-documents
[9]: https://www.arangodb.com/docs/stable/aql/tutorial-crud.html#read-documents
[10]: https://www.arangodb.com/docs/stable/aql/tutorial-crud.html#update-documents
[11]: https://www.arangodb.com/docs/stable/aql/tutorial-crud.html#delete-documents
[12]: assets/fdd.png
[13]: assets/gdq.png
[14]: https://www.arangodb.com/docs/stable/aql/graphs-traversals.html
[15]: assets/esv.png
[16]: assets/jlc.pdf
[17]: assets/vhm.sql
[18]: assets/mkn.sql
[19]: assets/xuf.xml
[20]: assets/btl.png
[21]: assets/ouu.png
[22]: assets/sju.png
[23]: assets/eja.png
[24]: assets/rwu.png
[25]: assets/olc.png
[26]: https://www.arangodb.com/docs/stable/aql/views-arango-search.html
[27]: assets/ing.png
[28]: assets/dxa.png
[29]: https://www.arangodb.com/docs/stable/aql/graphs-traversals.html
