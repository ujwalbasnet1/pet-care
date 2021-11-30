const fs = require('fs')
let gifList = [
    "https://media0.giphy.com/media/urKWmm7C2EGqI/giphy.gif",
    "https://media0.giphy.com/media/SUuFf9yZKFSb3rltFy/giphy.gif",
    "https://media0.giphy.com/media/cKguemLoLj3h3R5vKQ/giphy.gif",
    "https://media0.giphy.com/media/vq7R0XFCHxwqs0hN3f/giphy.gif",
    "https://media0.giphy.com/media/l1UdHchvx9G39j1BMY/giphy.gif",
    "https://media0.giphy.com/media/L8zUP1QhWmo5q/giphy.gif",
    "https://media0.giphy.com/media/1dHVyWQDbrIYjLV3MU/giphy.gif",
    "https://media0.giphy.com/media/Obo0zSLovadNxcjZNq/giphy.gif",
    "https://media0.giphy.com/media/13lUS5zohJ29A4/giphy.gif",
    "https://media0.giphy.com/media/lqVQEskOmoopO/giphy.gif",
    "https://media0.giphy.com/media/Rg9Am0QTVkyqs/giphy.gif",
    "https://media0.giphy.com/media/G24ANbymhNc08/giphy.gif",
    "https://media0.giphy.com/media/mQVXFnnL23oKk/giphy.gif",
    "https://media0.giphy.com/media/yPQcB2bQVBQ6k/giphy.gif",
    "https://media0.giphy.com/media/100UmkUrPhIWkM/giphy.gif",
    "https://media0.giphy.com/media/8DMcPUczc3cze/giphy.gif",
    "https://media0.giphy.com/media/FO4lgeCgKkC2I/giphy.gif",
    "https://media0.giphy.com/media/xj8uf5uhpwqty/giphy.gif",
    "https://media0.giphy.com/media/DyJb4KRLnVbUY/giphy.gif",
    "https://media0.giphy.com/media/xq1FxHkABwW7m/giphy.gif",
    "https://media0.giphy.com/media/PPEFC1OJZvo2Zs3mrT/giphy.gif",
    "https://media0.giphy.com/media/t5lLCCMvXvA1N3yYyu/giphy.gif",
    "https://media0.giphy.com/media/UvIApNhjzIEhi/giphy.gif",
    "https://media0.giphy.com/media/USLuiGsoe19bi3mfMN/giphy.gif",
    "https://media0.giphy.com/media/DOmoqqHVkhLos/giphy.gif",
    "https://media0.giphy.com/media/X6HWNLjWi9rw7PLVSO/giphy.gif",
    "https://media0.giphy.com/media/aCqb9YW7QclN3rtto5/giphy.gif",
    "https://media0.giphy.com/media/1XG6PDYJbI4w0/giphy.gif",
    "https://media0.giphy.com/media/1NZ9hxxVFPUCYNXyIJ/giphy.gif",
    "https://media0.giphy.com/media/txXOzETDm7NG8/giphy.gif",
    "https://media0.giphy.com/media/eGqomx6JU8tuteXKS7/giphy.gif",
    "https://media0.giphy.com/media/dAWl3WNApd8atxdNnl/giphy.gif",
    "https://media0.giphy.com/media/t3yZAynLPVkGY/giphy.gif",
    "https://media0.giphy.com/media/AORI3Pcli9JHG/giphy.gif",
    "https://media0.giphy.com/media/1qcgskldrb8IY3vMKf/giphy.gif",
    "https://media0.giphy.com/media/wsUtUtLR3A2XPvfLVs/giphy.gif",
    "https://media0.giphy.com/media/3oKIPwQh3REDHusotW/giphy.gif",
    "https://media0.giphy.com/media/3CYrXXV2WCFwlt89ui/giphy.gif",
    "https://media0.giphy.com/media/HnFPp38gcg0WQ/giphy.gif",
    "https://media0.giphy.com/media/IHkvVlY79WmpW/giphy.gif"
]

function generateObj() {
    let dataObj = gifList.map((el) => {
        return {
                "likes":  Math.floor(Math.random() * (1000 - 100 + 1)) + 100,
                "views":Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000,
                "url": el
              }
    });
    fs.writeFileSync('data_obj.json',JSON.stringify(dataObj,null,2))
}
generateObj()