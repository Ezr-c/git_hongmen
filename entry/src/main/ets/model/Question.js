export const QuestionData = [{
        word: "book",
        options: ["书籍", "笔", "橡⽪", "背包"],
        answer: "书籍",
        sentence: "I love to read a good book every night."
    },
    {
        word: "computer",
        options: ["电视", "电脑", "⼿机", "相机"],
        answer: "电脑",
        sentence: "I use the computer for work and entertainment."
    },
    {
        word: "apple",
        options: ["⾹蕉", "桃⼦", "梨", "苹果"],
        answer: "苹果",
        sentence: "She enjoys eating a crisp apple in the afternoon."
    },
    {
        word: "sun",
        options: ["⽉亮", "太阳", "星星", "地球"],
        answer: "太阳",
        sentence: "The sun provides warmth and light to our planet."
    },
    {
        word: "water",
        options: ["⽕", "⼟地", "⻛", "⽔"],
        answer: "⽔",
        sentence: "I always carry a bottle of water with me."
    },
    {
        word: "mountain",
        options: ["沙漠", "海洋", "平原", "⼭"],
        answer: "⼭",
        sentence: "The mountain range is covered in snow during winter."
    },
    {
        word: "flower",
        options: ["树⽊", "草地", "花", "灌⽊"],
        answer: "花",
        sentence: "The garden is filled with colorful flowers."
    },
    {
        word: "car",
        options: ["⾃⾏⻋", "⻜机", "船", "汽⻋"],
        answer: "汽⻋",
        sentence: "I drive my car to work every day."
    },
    {
        word: "time",
        options: ["空间", "时钟", "⽇历", "时间"],
        answer: "时间",
        sentence: "Time flies when you're having fun."
    },
    {
        word: "music",
        options: ["画", "舞蹈", "⾳乐", "戏剧"],
        answer: "⾳乐",
        sentence: "Listening to music helps me relax."
    },
    {
        word: "rain",
        options: ["雪", "雷电", "阳光", "⾬"],
        answer: "⾬",
        sentence: "I enjoy the sound of rain tapping on the window."
    },
    {
        word: "fire",
        options: ["冰", "⽕焰", "烟雾", "闪电"],
        answer: "⽕焰",
        sentence: "The campfire warmed us on a chilly evening."
    },
    {
        word: "friend",
        options: ["陌⽣⼈", "邻居", "家⼈", "朋友"],
        answer: "朋友",
        sentence: "A true friend is always there for you."
    },
    {
        word: "food",
        options: ["⽔果", "蔬菜", "⾁", "⻝物"],
        answer: "⻝物",
        sentence: "Healthy food is essential for a balanced diet."
    },
    {
        word: "color",
        options: ["⿊⾊", "⽩⾊", "红⾊", "颜⾊"],
        answer: "颜⾊",
        sentence: "The artist used a vibrant color palette."
    },
    {
        word: "bookshelf",
        options: ["椅⼦", "桌⼦", "书架", "床"],
        answer: "书架",
        sentence: "The bookshelf is filled with novels and reference books."
    },
    {
        word: "moon",
        options: ["太阳", "星星", "⽉亮", "地球"],
        answer: "⽉亮",
        sentence: "The moonlight illuminated the night sky."
    },
    {
        word: "school",
        options: ["公园", "商店", "医院", "学校"],
        answer: "学校",
        sentence: "Students go to school to learn and grow."
    },
    {
        word: "shoes",
        options: ["帽⼦", "⾐服", "裤⼦", "鞋⼦"],
        answer: "鞋⼦",
        sentence: "She bought a new pair of stylish shoes."
    },
    {
        word: "camera",
        options: ["电视", "电脑", "相机", "⼿机"],
        answer: "相机",
        sentence: "The photographer captured the moment with his camera."
    }];
export function getRandomQuestions(count) {
    let lenght = QuestionData.length;
    let indexes = [];
    while (indexes.length < count) {
        let index = Math.floor(Math.random() * lenght); // 创建一个 0-数组长度的随机数
        if (!indexes.includes(index)) {
            indexes.push(index);
        }
    }
    return indexes.map(index => QuestionData[index]);
}
//# sourceMappingURL=Question.js.map