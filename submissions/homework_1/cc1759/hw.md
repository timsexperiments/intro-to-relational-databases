# **Homework Assignment 1: Real Life Database Exampels**


## **Part 1: Sites With Databases**

3 sites that probally have databases are:
1. Discord
2. Amazon
3. Slippi.gg

Here is the types of databases I think each one uses and what kind of data they store in them...



### **Slippi.gg**

Slippi probally has a database for users and a database for the leaderboards:

For the user database it would probally be a *Relational Database*, and some data it would store would be:

**Table Name**
Users

**Rows *(primary key)***
- UserID: VARCHAR

**Columns**
- Username: VARCHAR
- Slipi_Suporter: BOOL
- Region: VARCHAR
- Rating/Elo: FLOAT
- Rank: VARCHAR
- Wins: INT
- Losses: INT
- Sets_Played: INT
- Char_Playrate: VARCHAR?
- (season)Placements: VARCHAR?
- Past_Seasons: a list of tables of data? Maybe a link othet tablesS for that seasons data somehow?


For Leaderboards, I would have a *Key-Value Database* where you can look up the placement and get a user ID back that you can then search in the user database to retrieve data. The name of the databases would be the reigion location, the key would be a placement, and the value would be the users ID:



### **Amazon**

Amazon probally databases for your lists, for your recomendations, for your past orders, for all there products, a list of sellers, and your cart.

For products they should have a rational data base, where the row is the product id, and the columnns are data like product name, product tags, item price, amnt in stock, the seller, its ratings, its description, product information (in JSON which i assumeing you can attach to a table in sql), and the reviews. Since I have nothing for listed for the table, have each table be a catagory so search is easier. Theres also should be a thing so you can change type of the object (like changing its color etc..), which woudl change a few of the things on the table like the products price and maybe the product details I'm not sure, but I havn't thought about how to do that yet. It would look somethign like:

**Table Name**
Catagory

**Rows *(primary key)***
- Product_ID: VARCHAR or INT AUTO_INCREMENT 

**Columns**
- Name: TEXT
- Author: VARCHAR
- Seller_ID: VARCHAR
- Tags: I would say set, but I think that would mean you have to list every possible tag for each product, and would have a max of 64 tags so im not sure.
- Price: FLOAT
- Stock_Amnt: INT
- Ratings: FLOAT
- Description: TEXT 
- Product_Info: JSON (somehow)
- Reviews: JSON


For past orders I would have a *Relational Database*, where the rows are auto incrementing INTS, and the columns have data such as product ID, date purchused, and date delivered. It would look something like this:

**Table Name**
Past_Orders

**Rows *(primary key)***
- ID: INT AUTO_INCREMENT

**Columns**
- Product_ID: VARCHAR or INT
- Date_Purchased: DATE
- Date_Delivered: DATE


I'm not sure how Amazon works for sellers, I would assume it just ties the products they sell to a regular account but im not sure. If so, it instead of list of sellers, this would just be a list of users, where the rows are user ID's and the columns are data such as the users name, users address, user payment info(idk if this would go here, that seems very insecure...), users listed products, and then other optional personalized info Amazon lets you put if you want like cloths size, pets, or intrests.


For your list database I would go with a *Key-Value Database*, with each key being the name of the list and the value being a list of the product values ID's, which are then looked up and grabbed from the products table. Though one thing I will say, is that they are ordered by last placed in list and IDK if you can do that with Key_Value pairs but idk. Otherwise it could be a relational database with table being the list, row being the an auto incramented index, and the collums having the products ID. Then its also expandable to any other info you'd want to add like date added to the list or whatever.


For recomendations, I think they would go with a *Vector Database* to search for similar products to what you've bought in the past, recently searched for, or have saved in your lists.


Your cart would either be more simaler to the past orders database or the list database I'm not sure. I would think the lists database because I don't think it would need all the extra information like the past orders table, so maybe litterally just make it the same as the lists



### **Discord**

Discord probally has databases direct messages, for your friends, for your joined servers, server messages, and for users and there settings.


For users it would probally have a *Relational Database*, with rows being your user ID (VARCHAR) and columns being things such as, disp_name, status, Tiene_Nitro, date joined, and all the settings (or they would have it)


For severs joined, I would have to choose a *Graph Database*. Have each user and each server be a node, and have a user be connected to the servers they've joined by node. This should provide for easy lookup for mutual server with other users (though im not sure how the lookup would be any faster than a list?)


For friend, I would have it be a *Graph Database* very simaler to the joined servers database, but with all the nodes being users, and the edges connecting those who are friends.


For private messaging and server messages, it would probally be a JSON each JSON itself hold data for a server. In it are messages as objects with different properties (author, time posted, message contents) nested within which channel its in. Since the server/DM messaging and channels are probally in JSON format, I would us a *Document Database* 







## **Part 2: Define a Rational Database**

A rational database is a collection of tables, each of which is devided into columns with predefined data types and with keys of predefined data types relating to each row.
