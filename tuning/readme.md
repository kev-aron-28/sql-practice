# Query tunning 

## The query processing pipeline
1. Parser -> builds the query tree 
2. Rewrite -> Decompose views into underlying table references
3. Planner -> Choose which strategy to execute the query given
4. Execute -> Run the strategy

## explain vs explain analyze

Explain -> BUild a query plan and display info about it 
Explain analyze -> Build a query plan, run it, and info about it
