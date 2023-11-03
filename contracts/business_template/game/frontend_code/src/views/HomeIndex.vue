<template>
  <div id="root" class="outer-container">
    <div class="start-container" v-show="start">
      <div class="login-container">
        <h3 class="hello-text">WELCOME!</h3>
        <input type="text" v-model="player.address" class="login-input1" placeholder="输入地址！设置后不可修改">
        <button class="login-btn" @click="startGame">开始！</button>
      </div>
    </div>
    <!-- 详情展示页面 -->
    <div class="start-container" v-show="isShowDetail">
      <div class="login-container" style="overflow: auto;">
        <h3 class="hello-text">{{showingObj.name}}</h3>
        <span class="detail-quality-text" :style="getFontColor(showingObj.quality)">
          {{showingObj.quality}}
        </span>
        <span class="detail-desc-text">{{showingObj.desc}}</span>
        <button class="login-btn" @click="closeDetail">关闭</button>
      </div>
    </div>
    <!-- 敌人属性展示页面 -->
    <div class="enemyAttr-container" v-show="isShowEnemyAttr">
      <div class="enemy-attr-container" style="overflow: auto;">
        <!-- 注意！v-for是可以遍历对象的！ -->
        <h3 class="enemy-attr-title">敌方属性</h3>
        <div class="enemy-attr-item-container">
          <span class="enemy-attr-item-span" v-for="(value,key,index) in enemy.attr"
            :key="index">{{key}}：{{value}}</span>
        </div>
        <button class="enemy-close-btn" @click="closeEnemyAttr">关闭</button>
      </div>
    </div>
    <!-- 商店页面 -->
    <div class="shop-container" v-show="isShowShop">

      <!-- 商店的展示详情页面 -->
      <div class="shop-detail-container" v-show="isShopShowDetail" style="overflow: auto;">
        <div class="login-container" style="overflow: auto;">
          <h3 class="hello-text">{{showingObj.name}}</h3>
          <span class="detail-quality-text" :style="getFontColor(showingObj.quality)">
            {{showingObj.quality}}
          </span>
          <span class="detail-desc-text">{{showingObj.desc}}</span>
          <button class="login-btn" @click="closeShopDetail">关闭</button>
          <button class="login-btn"
            @click="sellThing(showingObj.id, showingObj.type, getMoney(showingObj.buy, showingObj.quality))"
            style="bottom: -50px;">出售(+{{getMoney(showingObj.buy, showingObj.quality)}}G)</button>
        </div>
      </div>
      <!-- 商店的正式展示页面 -->
      <h1 class="shop-main-title">商店</h1>
      <button class="shop-refresh-btn" :style="judgeGoldEnough(getFreshShopGold())"
        @click="shopFresh(getFreshShopGold())">刷新(-{{getFreshShopGold()}}￥)</button>
      <span class="shop-gold">金币：{{player.money}}</span>
      <div class="shop-list-container">
        <div class="shop-item-origin" v-for="(item, index) in shopArr" :style="getShopLockStyle(item.isLock)"
          :key="index">
          <div :class="getShopItemClass(item.quality)">
            <span class="shop-title-span" :style="getFontColor(item.quality)">
              {{item.name}}
            </span>
            <span class="shop-qua-span" :style="getFontColor(item.quality)">
              {{item.quality}}
            </span>
            <span class="shop-desc-span">
              {{item.desc}}
            </span>
            <span class="shop-cost-span2" v-if="item.type=='技能'">
              花费体力：{{item.cost}}
            </span>
            <span class="shop-cost-span">
              金币：{{item.buy}}
            </span>
          </div>
          <button class="shop-buy-btn" :style="judgeGoldEnough(item.buy)"
            @click="shopBuyThing(item.id, item.type, item.buy)">购买</button>
          <button class="shop-lock-btn" @click="shopLockThing(item.id, item.isLock)">{{item.isLock?"解锁":"锁住"}}</button>
        </div>
      </div>
      <div class="shop-hasgot-things">
        <div class="shop-equ-container">
          <h3 class="head-text">装备</h3>
          <div style="margin-bottom: 40px;"></div>
          <div class="shop-equ-item" v-for="(item, index) in player.equList" :key="index"
            :style="getFontColor(item.quality)" @click="showShopDetail(item.id, item.type)">
            {{item.name}}
          </div>
        </div>
        <div class="shop-skill-container">
          <h3 class="head-text">技能</h3>
          <div style="margin-bottom: 40px;"></div>
          <div class="shop-skill-item" v-for="(item, index) in player.skillList" :key="index"
            :style="getFontColor(item.quality)" @click="showShopDetail(item.id, item.type)">
            {{item.name}}
          </div>
        </div>
        <div class="shop-attr-container">
          <h3 class="head-text">属性</h3>
          <div style="margin-bottom: 40px;"></div>
          <!-- 注意！v-for是可以遍历对象的！ -->
          <div class="shop-attr-item" v-for="(value,key,index) in player.afterAttr" :key="index">
            {{key}}：{{value}}
          </div>
        </div>
      </div>
      <button class="shop-start-btn" @click="leaveShop">GO</button>
    </div>

    <!-- 战斗结束的页面 -->
    <div class="finish-container" v-show="isFightFinish">
      <div class="finish-detail-container">
        <h3 class="finish-title">{{player.healthNow>0?'胜利！':'失败'}}</h3>
        <div class="finish-victory" v-if="player.healthNow>0" style="overflow: auto;">
          <span class="finish-text">你已经达到了{{cengNum}}层，下面是{{cengNum+1}}层</span>
          <span class="finish-gold-text">获得 <span
              style="color: gold; font-size: 20px;font-weight: 600;">{{goldGet}}</span> 金币</span>
          <button class="finish-btn" @click="goShop">点击继续，前去商店</button>
        </div>
        <div class="gain-container" v-show="isShowGain">
          <span class="finish-gain">获得加成：</span>
          <div class="gainner-get">
            <span>{{attrGet}}</span>
          </div>
        </div>
        <div class="finish-defeat" v-if="player.healthNow<=0">
          <span class="finish-text">你达到了{{cengNum-1}}层，倒在了{{cengNum}}层，被 {{enemy.name}} 斩于马下</span>
          <span class="finish-text-record" v-if="cengNum>maxCengNum">恭喜您破纪录了！</span>
          <button class="finish-btn" @click="finishAll">结束</button>
        </div>
      </div>
    </div>

    <!-- 正式进入的页面 -->
    <!-- 顶部血条以及名字部分 -->
    <div class="top-container">
      <span class="name-left">
        {{player.name}}
        ---
        {{player.healthNow}}/{{player.health}}
      </span>
      <div class="blood-container-left">
        <div class="blood-left" style="width: 100%;" ref="yourBlood"></div>
      </div>
      <div class="cost-container">
        体力：{{player.feeNow}}/{{player.feeTotal}}
        <span v-show="player.skillSpecial.id220" style="color: blueviolet;">(法术免疫)</span>
        <span v-show="player.skillSpecial.id221" style="color: orangered;">(物理免疫)</span>
        <span v-show="player.skillSpecial.id225||player.equSpecial.id148" style="color: darkgoldenrod;">(受伤减半)</span>
        <span v-show="player.equSpecial.id152" style="color: red;">(未受伤回合{{id152Count}}/5)</span>
        <span v-show="player.skillSpecial.id224">(额外费:{{feeLastTurnGet}})</span>
        <span v-show="player.skillSpecial.id228" style="color: cornflowerblue;">(无视防御)</span>
        <span v-show="player.equSpecial.id153&&(!id153Used)" style="color: rgb(0, 255, 166);">可复活</span>
        <span v-show="player.skillSpecial.id229" style="color: royalblue;">(免疫)</span>
        <span v-show="player.equSpecial.id150" style="color: rgb(206, 65, 225);">(无视闪避)</span>
      </div>

      <span class="ceng-span">当前层数：{{cengNum}}</span>
      <span class="max-ceng-span">之前的最大层数：{{maxCengNum}}</span>

      <span class="name-right">
        {{enemy.name}}
        ---
        {{enemy.healthNow}}/{{enemy.health}}
        <a href="javascript:void(0)" class="enemy-attr" @click="showEnemyAttr">属性</a>
      </span>
      <div class="blood-container-right">
        <div class="blood-right" style="width: 100%;" ref="enemyBlood"></div>
      </div>
      <button class="finish-turn-btn" @click="finishTurn">点击结束回合(或按空格键)</button>
      <div class="show-your-turn" v-show="isJump">
        跳过敌方回合！
      </div>
      <div class="show-your-turn" v-show="showIsYourTurn">
        你的回合！
      </div>
      <div class="show-your-turn" v-show="showNo">
        体力不足！
      </div>
      <div class="show-your-turn" v-show="showYouLive">
        您已复活！
      </div>
    </div>

    <!-- 中间区域 -->
    <div class="show-num-container">
      <span :style="isBoom?'color: red;':''" class="num-player"
        v-show="!isMyTurn">{{isBoom?"暴击":""}}{{numGetPlayer}}</span>
      <span style="color: green;" class="num-player" v-show="isMyTurn&&numPlusPlayer!=='+0'">{{numPlusPlayer}}</span>
      <img src="../assets/1.png" class="player-img" ref="player-i" :class="isPlayerPlay?'play-ani1':''">
      <span style="color: green;" class="num-enemy" v-show="!isMyTurn&&numPlusEnemy!=='+0'">{{numPlusEnemy}}</span>
      <span :style="isBoom?'color: red;':''" class="num-enemy"
        v-show="isMyTurn">{{isBoom?"暴击":""}}{{numGetEnemy}}</span>
      <img src="../assets/2.png" class="monster-img" ref="enemy-i" :class="isEnemyPlay?'play-ani2':''">
    </div>

    <!-- 下部装备技能区 -->
    <div class="bottom-container">
      <div class="equ-container">
        <h3 class="head-text">已有装备</h3>
        <div style="margin-bottom: 40px;"></div>

        <div v-for="(item, index) in player.equList" class="equ-item" :key="index" :style="getFontColor(item.quality)"
          @click="showDetail(item.id)">
          {{item.name}}
        </div>
      </div>

      <div class="skill-container">
        <div v-for="(item, index) in player.skillList" class="skill-item-origin"
          :style="isMyTurn?'':'pointer-events: none;'" :key="index" @click="dealSkill(item.id)">
          <div :class="getSkillClass(item.quality)">
            <span class="skill-title-span" :style="getFontColor(item.quality)">
              {{item.name}}
            </span>
            <span class="skill-qua-span" :style="getFontColor(item.quality)">
              {{item.quality}}
            </span>
            <span class="skill-desc-span">
              {{item.desc}}
            </span>
            <span class="skill-cost-span">
              花费行动力：{{item.cost}}
            </span>
          </div>
        </div>
      </div>

      <div class="attr-container">
        <h3 class="head-text">你的属性</h3>
        <div style="margin-bottom: 40px;"></div>
        <!-- 注意！v-for是可以遍历对象的！ -->
        <div class="attr-item" v-for="(value,key,index) in player.afterAttr" :key="index">
          <span class="attr-item-span">{{key}}：{{value}}</span>
        </div>
      </div>
    </div>
  </div>
</template>
<script src="../api/AfterFight/getShopThing.js"></script>
<script>
  import axios from 'axios'
  function judgeInArr (arr, index, type) {
    if (arr.length === 0) {
      return false;
    }
    for (let i = 0; i < arr.length; ++i) {
      if (type === "装备") {
        if (arr[i].id === index + 100) {
          return true;
        }
      } else if (type === "技能") {
        if (arr[i].id === index + 200) {
          return true;
        }
      }
    }
    return false;
  }
  function highQuaInEqu (index, arr) {//专供检查装备的检查函数。也需要做防止重复。
    if (index >= 47) {
      for (let i = 0; i < arr.length; ++i) {
        if (index + 100 === arr[i].id) {
          return true;
        }
      }
    }
    return false;
  }
  function getShopThing (nowLock, nowEqu, nowSkill, cengNum, lenNeed) {
    //改为返回数组 数组中不会返回相同/已经拥有的技能的元素
    //装备几率要比技能大
    let type;
    let arrRe = [];
    let index;
    for (let i = 0; i < lenNeed; ++i) {//针对整个arr的循环
      type = Math.floor(Math.random() * 3) <= 1 ? "装备" : "技能";
      if (type === "装备") {
        if (cengNum <= 3) {
          index = Math.floor(Math.random() * 24);//获取index
          while (judgeInArr(nowLock, index, "装备") || judgeInArr(arrRe, index, "装备")) {
            index = Math.floor(Math.random() * 24);
          }
          arrRe.push(equipmentList[index]);
        } else if (cengNum <= 5) {
          index = Math.floor(Math.random() * 38);//获取index 
          while (judgeInArr(nowLock, index, "装备") || judgeInArr(arrRe, index, "装备")) {
            index = Math.floor(Math.random() * 38);
          }
          arrRe.push(equipmentList[index]);
        } else {//全 加上限制已经买了的神话与传说仅可买一件 一旦买了就不会在商店中刷新出来了。
          index = Math.floor(Math.random() * 55);//获取index
          while (judgeInArr(nowLock, index, "装备") || judgeInArr(arrRe, index, "装备") || highQuaInEqu(index, nowEqu)) {
            index = Math.floor(Math.random() * 55);//获取index
          }
          arrRe.push(equipmentList[index]);
        }
      } else if (type === "技能") {
        if (cengNum <= 3) {
          index = Math.floor(Math.random() * 14);//获取index
          while (judgeInArr(nowLock, index, "技能") || judgeInArr(arrRe, index, "技能") || judgeInArr(nowSkill, index, "技能")) {
            index = Math.floor(Math.random() * 14);
          }
          arrRe.push(skillList[index]);
        } else if (cengNum <= 5) {
          index = Math.floor(Math.random() * 26);//获取index
          while (judgeInArr(nowLock, index, "技能") || judgeInArr(arrRe, index, "技能") || judgeInArr(nowSkill, index, "技能")) {
            index = Math.floor(Math.random() * 26);
          }
          arrRe.push(skillList[index]);
        } else {
          index = Math.floor(Math.random() * 31);//获取index 
          while (judgeInArr(nowLock, index, "技能") || judgeInArr(arrRe, index, "技能") || judgeInArr(nowSkill, index, "技能")) {
            index = Math.floor(Math.random() * 31);
          }
          arrRe.push(skillList[index]);
        }
      }
    }

    return arrRe;//返回生成的数组。
  }
  export default {
    name: "HomeIndex",
    data () {
      return {
        player: {
          name: "",
          address: "",
          health: 100,
          healthNow: 100,
          equList: [],
          skillList: [
            // skillList[0],
            // skillList[2],
          ],
          //下面是基础属性
          attr: {
            "物理攻击": 10,
            "法术攻击": 10,
            "物理防御": 8,
            "法术防御": 8,
            "暴击率": 0,
            "闪避率": 0,
            "吸血": 0,
            "暴击效果": 1.5,
          },
          //下面是计算了各种加成之后的值
          afterAttr: {
            "物理攻击": 10,
            "法术攻击": 10,
            "物理防御": 8,
            "法术防御": 8,
            "暴击率": 0,
            "闪避率": 0,
            "吸血": 0,
            "暴击效果": 1.5,
          },
          skillSpecial: {
            id204: false,
            id206: false,
            id218: false,
            id219: false,
            id220: false,
            id221: false,
            id224: false,
            id225: false,
            id228: false,
            id229: false,
          },
          equSpecial: {
            id147: false,
            id148: false,
            id149: false,
            id150: false,
            id151: false,
            id152: false,
            id153: false,
            id154: false,
          },
          feeNow: 10,
          feeTotal: 10,
          money: 0,
        },
        enemy: {
          name: getEnemyName(),
          health: 100,
          healthNow: 100,
          attr: {
            "物理攻击": 5,
            "法术攻击": 5,
            "物理防御": 4,
            "法术防御": 4,
            "暴击率": 0,
            "闪避率": 0,
            "吸血": 0,
            "暴击效果": 2,
          },
        },
        start: true,
        cengNum: 1,
        maxCengNum: 0,
        isShowDetail: false,
        showingObj: {},
        isShowShop: false,
        freshShopTimes: 0,
        shopArr: [],
        lockShopArr: [],
        isShopShowDetail: false,
        isFightFinish: false,
        isShowEnemyAttr: false,
        isShowGain: false,
        isMyTurn: true,
        numGetPlayer: '',
        numGetEnemy: '',
        isBoom: false,
        lastTurnHealth: {},
        feeLastTurnGet: 0,
        harmYouDid: 0,
        id153Used: false,
        id152Count: 0,
        id152Harm: 0,
        isPlayerPlay: false,
        isEnemyPlay: false,
        numPlusEnemy: '',
        numPlusPlayer: '',
        showIsYourTurn: false,
        showNo: false,
        showYouLive: false,
        isJump: false,
        isOut: false,
        beforeMiss: 0,
      };
    },
    mounted () {
      this.getMaxCeng();
      this.getName();
      this.bind()
    },
    beforeDestroy () {
      window.removeEventListener("keyup", this.dealKeyUp, false);
    },

    methods: {
      bind () {
        window.addEventListener("keyup", this.dealKeyUp);
      },
      dealKeyUp (e) {
        if (e.keyCode === 32) {
          this.finishTurn();
        }
      },
      getName () {
        if (localStorage.getItem('name') !== null) {
          this.player.name = localStorage.getItem('name');
        } else {
          this.player.name = "";
        }
      },
      getMaxCeng () {
        if (localStorage.getItem('max') !== null) {
          this.maxCengNum = localStorage.getItem('max');
        } else {
          this.maxCengNum = "无";
        }
      },
      getFontColor (qua) {
        switch (qua) {
          case "传说": {
            return "color: rgb(251, 127, 10); font-style: italic; font-size: 18px; font-weight: 900;"
          }
          case "神话": {
            return "color: red; font-weight: 600;"
          }
          case "史诗": {
            return "color: blueviolet; font-weight: 600;"
          }
          case "稀有": {
            return "color: blue; font-weight: 600;"
          }
          case "普通": {
            return "color: black; font-weight: 600;"
          }
        }
      },
      getSkillClass (qua) {
        switch (qua) {
          case "传说": {
            return "skill-item-legend"
          }
          case "神话": {
            return "skill-item-mythology"
          }
          case "史诗": {
            return "skill-item-epic"
          }
          case "稀有": {
            return "skill-item-rare"
          }
          case "普通": {
            return "skill-item-normal"
          }
        }
      },
      showDetail (id) {
        let i;
        for (i = 0; i < this.player.equList.length; ++i) {
          if (this.player.equList[i].id == id) {
            this.showingObj = this.player.equList[i];
            this.isShowDetail = true;
            return true
          }
        }
      },
      closeDetail () {
        this.isShowDetail = false;
      },
      //下面是商店相关的
      getFreshShopGold () {
        let cengNumLink = this.cengNum * 3
        if (cengNumLink > 30) cengNumLink = 30;
        return (cengNumLink + this.freshShopTimes * 4) * 1;
      },
      getShopItemClass (qua) {
        switch (qua) {
          case "传说": {
            return "shop-item-legend"
          }
          case "神话": {
            return "shop-item-mythology"
          }
          case "史诗": {
            return "shop-item-epic"
          }
          case "稀有": {
            return "shop-item-rare"
          }
          case "普通": {
            return "shop-item-normal"
          }
        }
      },
      judgeGoldEnough (value) {
        if (this.player.money < value) {
          return "color: red;";
        } else {
          return "";
        }
      },
      showShopDetail (id, type) {
        this.isShopShowDetail = true;
        let i;
        if (type == "装备") {
          for (i = 0; i < this.player.equList.length; ++i) {
            if (this.player.equList[i].id == id) {
              this.showingObj = this.player.equList[i];
              this.isShopShowDetail = true;
              return true;
            }
          }
        } else {
          for (i = 0; i < this.player.skillList.length; ++i) {
            if (this.player.skillList[i].id == id) {
              this.showingObj = this.player.skillList[i];
              this.isShopShowDetail = true;
              return true;
            }
          }
        }
      },
      showEnemyAttr () {
        this.isShowEnemyAttr = true
      },
      closeEnemyAttr () {
        this.isShowEnemyAttr = false
      },
      closeShopDetail () {
        this.isShopShowDetail = false;
      },
      getMoney (oldVal, qua) {
        switch (qua) {
          case "传说": {
            return Math.ceil(oldVal * 0.8);
          }
          case "神话": {
            return Math.ceil(oldVal * 0.6);
          }
          case "史诗": {
            return Math.ceil(oldVal * 0.5);
          }
          case "稀有": {
            return Math.ceil(oldVal * 0.4);
          }
          case "普通": {
            return Math.ceil(oldVal * 0.2);
          }
        }
      },
      sellThing (id, type, money) {
        if (type == "装备") {
          let i;
          for (i = 0; i < this.player.equList.length; ++i) {
            if (this.player.equList[i].id == id) {
              this.player.equList.splice(i, 1);
              this.player.money += money;
              this.isShopShowDetail = false;
              this.countEqu(false, id);//重新计算装备属性加成
              return true;
            }
          }
        } else {
          // axios.post
          // console.log(id)

          axios.post("http://localhost:8083/webase/tionjineng/" + this.player.address + "/" + id).then((res) => {
            // this.player.money = res.data[0]
            console.log(res.data)
          }).catch((error) => {
            alert(error)
            console.log(error)
          })
          let i;
          for (i = 0; i < this.player.skillList.length; ++i) {
            if (this.player.skillList[i].id == id) {
              this.player.skillList.splice(i, 1);
              this.player.money += money;
              this.isShopShowDetail = false;
              return true;
            }
          }
        }
      },
      initShop () {
        this.freshShopTimes = 0;
        var i;
        var objArr = [];
        objArr = getShopThing(this.lockShopArr, this.player.equList, this.player.skillList, this.cengNum, 4 - this.lockShopArr.length);
        this.shopArr = objArr.concat(this.lockShopArr);
      },

      enemyTurn () {
        this.isBoom = false;
        if (this.player.equSpecial.id149 && this.harmYouDid % 2 === 0) {
          this.isJump = true;
          setTimeout(() => {
            this.isJump = false;
          }, 300);
          //回合结束，初始化你的回合 跳过
          this.numGetEnemy = '';
          this.numPlusPlayer = '';
          if (this.player.skillSpecial.id224) {
            this.player.feeNow = this.player.feeTotal;
            this.player.feeNow += this.feeLastTurnGet;
            this.feeLastTurnGet = 0;
            this.player.skillSpecial.id224 = false;
          } else {
            this.player.feeNow = this.player.feeTotal;
          }

          if (this.player.skillSpecial.id219) {
            if (this.isOut) {
              this.player.afterAttr["闪避率"] = this.dealNum(this.beforeMiss);
            } else {
              this.player.afterAttr["闪避率"] -= 0.2;
              this.player.afterAttr["闪避率"] = this.dealNum(this.player.afterAttr["闪避率"]);
            }
            this.player.skillSpecial.id219 = false;
            this.isOut = false;
          }
          if (this.player.skillSpecial.id220) {
            this.player.skillSpecial.id220 = false;
          }
          if (this.player.skillSpecial.id221) {
            this.player.skillSpecial.id221 = false;
          }
          if (this.player.skillSpecial.id225) {
            this.player.skillSpecial.id225 = false;
          }
          if (this.player.skillSpecial.id229) {
            this.player.skillSpecial.id225 = false;
          }
          if (this.player.equSpecial.id152) {
            if (this.id152Harm === 0) {
              ++this.id152Count;
              if (this.id152Count >= 5) {
                this.enemy.healthNow = 0;
              }
            } else {
              this.id152Count = 0;
            }
          }
          setTimeout(() => {
            this.isMyTurn = true;
            this.showIsYourTurn = true;
          }, 400);
          setTimeout(() => {
            this.showIsYourTurn = false;
          }, 1500)
          return 0;
        }

        //进行敌方回合
        this.isEnemyPlay = true;
        let str;
        if ((this.enemy.attr["物理攻击"] - (this.player.afterAttr["物理防御"] * 0.3)) > (this.enemy.attr["法术攻击"] - (this.player.afterAttr["法术防御"] * 0.35))) {
          str = "物理";
        } else {
          str = "法术";
        }
        if (this.player.skillSpecial.id220) {
          str = "物理";
        }
        if (this.player.skillSpecial.id221) {
          str = "法术";
        }
        this.doHarm("你", this.enemy.attr[str + "攻击"] * 2, str);
        setTimeout(() => {
          this.isEnemyPlay = false;
        }, 500)


        //回合结束，初始化你的回合
        this.numGetEnemy = '';
        this.numPlusPlayer = '';
        if (this.player.skillSpecial.id224) {
          this.player.feeNow = this.player.feeTotal;
          this.player.feeNow += this.feeLastTurnGet;
          this.feeLastTurnGet = 0;
          this.player.skillSpecial.id224 = false;
        } else {
          this.player.feeNow = this.player.feeTotal;
        }

        if (this.player.skillSpecial.id219) {
          if (this.isOut) {
            this.player.afterAttr["闪避率"] = this.dealNum(this.beforeMiss);
          } else {
            this.player.afterAttr["闪避率"] -= 0.2;
            this.player.afterAttr["闪避率"] = this.dealNum(this.player.afterAttr["闪避率"]);
          }
          this.player.skillSpecial.id219 = false;
          this.isOut = false;
        }
        if (this.player.skillSpecial.id220) {
          this.player.skillSpecial.id220 = false;
        }
        if (this.player.skillSpecial.id221) {
          this.player.skillSpecial.id221 = false;
        }
        if (this.player.skillSpecial.id225) {
          this.player.skillSpecial.id225 = false;
        }
        if (this.player.skillSpecial.id229) {
          this.player.skillSpecial.id225 = false;
        }
        if (this.player.equSpecial.id152) {
          if (this.id152Harm === 0) {
            ++this.id152Count;
            if (this.id152Count >= 5) {
              this.enemy.healthNow = 0;
            }
          } else {
            this.id152Count = 0;
          }
        }

        setTimeout(() => {
          this.isMyTurn = true;
          this.showIsYourTurn = true;
          this.isBoom = false;
        }, 700);
        setTimeout(() => {
          this.showIsYourTurn = false;
        }, 1500);
      },

      finishTurn () {
        this.isBoom = false;
        this.numGetPlayer = '';
        this.numPlusEnemy = '';
        this.isMyTurn = false;
        this.lastTurnHealth = this.player.healthNow;
        this.enemyTurn();
      },

      //处理复杂的逻辑-------------------------------------------------------------
      doHarm (ToWho, value, type) {//造成伤害
        if (value <= 0) {
          value = 0;
        }
        if (ToWho === "对手") {
          //计算暴击以及暴击效果然后得到最终伤害值
          this.isBoom = false;
          let r = Math.floor(Math.random() * 100 + 1);//产生1-100的随机数
          let valid = this.player.afterAttr["暴击率"] * 100;
          if (r <= valid || this.player.equSpecial.id147) {//暴击
            if (this.player.afterAttr["暴击效果"] >= 1) {
              value = Math.ceil(value * this.player.afterAttr["暴击效果"]);
            }
            this.isBoom = true;
            this.player.skillSpecial.id206 = false;
          } else if (this.player.skillSpecial.id206) {//特殊技能强制暴击
            if (this.player.afterAttr["暴击效果"] >= 1) {
              value = Math.ceil(value * this.player.afterAttr["暴击效果"]);
            }
            this.player.skillSpecial.id206 = false;
            this.isBoom = true;
          }
          if (this.player.skillSpecial.id204) {
            this.recoveryHealth("你", Math.floor(value * 0.5));
            this.player.skillSpecial.id204 = false;
          }

          //是不是无视防御
          if (this.player.skillSpecial.id228) {
            this.player.skillSpecial.id228 = false;
          } else {
            if (type === "物理") {
              if (this.enemy.attr["物理防御"] < 0) {
                value -= 0;
              } else {
                value -= Math.ceil(this.enemy.attr["物理防御"] * 0.3);
              }

            } else if (type === "法术") {
              if (this.enemy.attr["法术防御"] < 0) {
                this.enemy.attr["法术防御"] = 0;
                value -= 0;
              } else {
                value -= Math.ceil(this.enemy.attr["法术防御"] * 0.35);
              }

            }
            if (value <= 0) {
              value = 1;
            }
          }
          //计算是不是闪避了
          if (this.enemy.attr["闪避率"] > 0 && (!this.player.equSpecial.id150)) {
            let m = Math.floor(Math.random() * 100 + 1);//产生1-100的随机数
            let miss = this.enemy.attr["闪避率"] * 100;
            if (m <= miss) {//成功闪避
              this.numGetEnemy = '闪避！';
              return true;
            }
          }
          //最终造成伤害
          this.enemy.healthNow -= value
          if (this.player.equSpecial.id149) {
            this.harmYouDid = value;
          }
          //处理吸血
          if (this.player.afterAttr["吸血"] > 0) {
            if (this.player.skillSpecial.id218) {
              this.player.skillSpecial.id218 = false;
              this.recoveryHealth("你", Math.floor(2 * this.player.afterAttr["吸血"] * value));
            } else {
              this.recoveryHealth("你", Math.floor(this.player.afterAttr["吸血"] * value));
            }
          }
          //展示出去
          value = value.toString();
          this.numGetEnemy = `(${type})-${value}`;
        } else if (ToWho === "你") {//对你造成伤害
          if (this.player.skillSpecial.id229) {
            this.numGetPlayer = '免疫';
            this.id152Harm = 0;
            return true;
          }
          if (this.player.skillSpecial.id220 && type === "法术") {
            this.numGetEnemy = '免疫';
            this.id152Harm = 0;
            return true;
          }
          if (this.player.skillSpecial.id221 && type === "物理") {
            this.numGetEnemy = '免疫';
            this.id152Harm = 0;
            return true;
          }
          //计算暴击以及暴击效果然后得到最终伤害值
          this.isBoom = false;
          let r = Math.floor(Math.random() * 100 + 1);//产生1-100的随机数
          let valid = this.enemy.attr["暴击率"] * 100;
          if (r <= valid) {//暴击
            value = Math.ceil(value * this.enemy.attr["暴击效果"]);
            this.isBoom = true;
          }
          if (type === "物理") {
            if (this.player.afterAttr["物理防御"] < 0) {
              value -= 0;
            } else {
              value -= Math.ceil(this.player.afterAttr["物理防御"] * 0.3);
            }

          } else if (type === "法术") {
            if (this.player.afterAttr["法术防御"] < 0) {
              value -= 0;
            } else {
              value -= Math.ceil(this.player.afterAttr["法术防御"] * 0.35);
            }

          }
          if (value <= 0) {
            value = 1;
          }
          //计算是不是闪避了
          if (this.enemy.attr["闪避率"] > 0) {
            let m = Math.floor(Math.random() * 100 + 1);//产生1-100的随机数
            let miss = this.player.afterAttr["闪避率"] * 100;
            if (m <= miss) {//成功闪避
              this.numGetPlayer = '闪避！';
              this.id152Harm = 0;
              return true;
            }
          }
          if (this.player.equSpecial.id148) {
            value = Math.ceil(value / 2);
          }
          //是不是伤害减半？
          if (this.player.skillSpecial.id225) {
            value = Math.ceil(value / 2);
          }
          //最终造成伤害
          this.player.healthNow -= value;
          this.id152Harm = value;
          //处理吸血
          if (this.enemy.attr["吸血"] > 0) {
            this.recoveryHealth("对手", Math.floor(this.enemy.attr["吸血"] * value));
          }
          //展示出去
          value = value.toString();
          this.numGetPlayer = `(${type})-${value}`;
        }
      },

      recoveryHealth (ToWho, value) {//恢复生命值
        if (ToWho === "你") {
          if (this.player.healthNow + value <= this.player.health) {
            this.player.healthNow += value;
            value = value.toString();
            this.numPlusPlayer = `+${value}`;
          } else {
            let str;
            let num = this.player.health - this.player.healthNow;
            num = num.toString();
            this.numPlusPlayer = `+${num}`;
            this.player.healthNow = this.player.health;
          }
        } else if (ToWho === "对手") {
          if (this.enemy.healthNow + value <= this.enemy.health) {
            this.enemy.healthNow += value;
            value = value.toString();
            this.numPlusEnemy = `+${value}`;
          } else {
            let num = this.enemy.health - this.enemy.healthNow;
            num = num.toString();
            this.numPlusEnemy = `+${num}`;
            this.enemy.healthNow = this.enemy.health;
          }
        }
      },

      //技能处理函数
      dealSkill (id) {
        // console.log(id);
        this.isBoom = false;
        this.isPlayerPlay = true;
        setTimeout(() => {
          this.isPlayerPlay = false;
        }, 400);
        if (this.player.feeNow < skillList[id - 200].cost) {
          this.showNo = true;
          setTimeout(() => {
            this.showNo = false;
          }, 1500);
          return false;
        }
        switch (id) {
          case 200: {
            this.doHarm("对手", this.player.afterAttr["物理攻击"], "物理");
            this.player.feeNow -= 3;
            break;
          }

          case 201: {
            this.player.afterAttr["物理防御"] += Math.floor(this.player.afterAttr["物理防御"] * 0.1);
            this.player.feeNow -= 3;
            break;
          }

          case 202: {
            this.doHarm("对手", this.player.afterAttr["法术攻击"], "法术");
            this.player.feeNow -= 3;
            break;
          }

          case 203: {
            this.player.afterAttr["法术防御"] += Math.floor(this.player.afterAttr["法术防御"] * 0.1);
            this.player.feeNow -= 3;
            break;
          }

          case 204: {
            this.player.skillSpecial.id204 = true;
            this.player.feeNow -= 6;
            break;
          }

          case 205: {
            this.recoveryHealth("你", Math.ceil(this.player.health * 0.045));
            this.player.feeNow -= 1;
            break;
          }

          case 206: {
            this.player.skillSpecial.id206 = true;
            this.player.feeNow -= 5;
            break;
          }

          case 207: {
            this.enemy.attr["物理攻击"] -= Math.floor(this.enemy.attr["物理攻击"] * 0.1);
            this.player.feeNow -= 4;
            break;
          }

          case 208: {
            this.enemy.attr["物理防御"] -= Math.floor(this.enemy.attr["物理防御"] * 0.1);
            this.player.feeNow -= 4;
            break;
          }

          case 209: {
            this.enemy.attr["法术防御"] -= Math.floor(this.enemy.attr["法术防御"] * 0.1);
            this.player.feeNow -= 4;
            break;
          }

          case 210: {
            this.enemy.attr["法术攻击"] -= Math.floor(this.enemy.attr["法术攻击"] * 0.1);
            this.player.feeNow -= 4;
            break;
          }

          case 211: {
            this.doHarm("对手", Math.ceil(this.player.afterAttr["物理攻击"] * 0.65), "物理");
            this.player.feeNow -= 2;
            break;
          }

          case 212: {
            this.doHarm("对手", Math.ceil(this.player.afterAttr["法术攻击"] * 0.65), "法术");
            this.player.feeNow -= 2;
            break;
          }

          case 213: {
            this.player.afterAttr["物理防御"] += Math.floor(this.player.attr["物理防御"] * 0.1);
            this.player.afterAttr["法术防御"] += Math.floor(this.player.attr["法术防御"] * 0.1);
            this.player.feeNow -= 3;
            break;
          }

          case 214: {
            this.doHarm("对手", this.player.afterAttr["物理防御"], "物理");
            this.player.feeNow -= 4;
            break;
          }

          case 215: {
            this.doHarm("对手", this.player.afterAttr["物理防御"], "法术");
            this.player.feeNow -= 4;
            break;
          }

          case 216: {
            this.doHarm("对手", this.player.afterAttr["法术防御"], "法术");
            this.player.feeNow -= 4;
            break;
          }

          case 217: {
            this.doHarm("对手", this.player.afterAttr["法术防御"], "物理");
            this.player.feeNow -= 4;
            break;
          }

          case 218: {
            this.player.skillSpecial.id218 = true;
            this.player.feeNow -= 2;
            break;
          }

          case 219: {
            if (this.player.afterAttr["闪避率"] + 0.2 <= 1) {
              this.player.afterAttr["闪避率"] += 0.2;
              this.player.skillSpecial.id219 = true;
            } else {
              this.beforeMiss = this.player.afterAttr["闪避率"];
              this.isOut = true;
              this.player.afterAttr["闪避率"] = 1;
              this.player.skillSpecial.id219 = true;
            }
            this.player.feeNow -= 4;
            break;
          }

          case 220: {
            this.player.skillSpecial.id220 = true;
            this.player.feeNow -= 6;
            break;
          }

          case 221: {
            this.player.skillSpecial.id221 = true;
            this.player.feeNow -= 6;
            break;
          }

          case 222: {
            this.player.healthNow = this.lastTurnHealth;
            this.player.feeNow -= 6;
            break;
          }

          case 223: {
            this.recoveryHealth("你", Math.ceil(this.player.health * 0.2));
            this.player.afterAttr["物理防御"] += Math.ceil(this.player.attr["物理防御"] * 0.05);
            this.player.afterAttr["法术防御"] += Math.ceil(this.player.attr["法术防御"] * 0.05);
            this.player.feeNow -= 8;
            break;
          }

          case 224: {
            this.player.skillSpecial.id224 = true;
            this.feeLastTurnGet = this.player.feeNow;
            this.player.feeNow = 0;
            break;
          }

          case 225: {
            this.player.skillSpecial.id225 = true;
            this.player.feeNow -= 6;
            break;
          }

          case 226: {
            let init = false;
            if (this.player.healthNow > this.enemy.health) {
              this.player.healthNow = this.enemy.healthNow;
              this.enemy.healthNow = this.enemy.health;
              init = true;
            }
            if (this.enemy.healthNow > this.player.health) {
              this.enemy.healthNow = this.player.healthNow;
              this.player.healthNow = this.player.health;
              init = true;
            }

            if (!init) {
              let temp = this.player.healthNow;
              this.player.healthNow = this.enemy.healthNow;
              this.enemy.healthNow = temp;
            }

            this.feeNow -= 5;
            break;
          }

          case 227: {
            let harm = Math.floor((this.player.health - this.player.healthNow) / 2);
            this.recoveryHealth("你", this.player.health - this.player.healthNow);
            this.doHarm("对手", harm, "法术");
            this.player.feeNow -= 10;
            break;
          }

          case 228: {
            this.player.skillSpecial.id228 = true;
            this.player.feeNow -= 0;
            break;
          }

          case 229: {
            this.player.skillSpecial.id229 = true;
            this.player.feeNow -= 10;
            break;
          }

          case 230: {
            this.enemy.healthNow = 0;
            this.player.feeNow -= 30;
            break;
          }

        }
      },

      //处理身上的装备属性
      countEqu (on = true, id) {
        // console.log(this.player.attr); 
        this.player.afterAttr = JSON.parse(JSON.stringify(this.player.attr));
        //此处加上装备加成统一计算
        if (!on) {//githe 脱掉特殊装备
          if (id === 115) {
            this.player.health -= 10;
          } else if (id === 116) {
            this.player.health -= 10;
          } else if (id === 117) {
            this.player.health -= 20;
          } else if (id === 123) {
            this.player.health += 10;
          } else if (id === 136) {
            this.player.health -= 70;
          } else if (id === 142) {
            this.player.health -= 30;
          } else if (id === 145) {
            this.player.health -= 100;
          } else if (id === 147) {
            this.player.equSpecial.id147 = false;
          } else if (id === 148) {
            this.player.equSpecial.id148 = false;
          } else if (id === 149) {
            this.player.equSpecial.id149 = false;
          } else if (id === 150) {
            this.player.equSpecial.id150 = false;
          } else if (id === 151) {
            this.player.equSpecial.id151 = false;
            this.player.health -= 100;
          } else if (id === 152) {
            this.player.equSpecial.id152 = false;
            this.id152Count = 0;
            this.id152Harm = 0;
          } else if (id === 153) {
            this.player.equSpecial.id153 = false;
            this.id153Used = false;
          } else if (id === 154) {
            this.player.equSpecial.id154 = false;
          }

        }
        this.player.equList.forEach((item) => {
          this.dealEqu(on, item.id);
        })
      },

      //装备处理函数
      dealEqu (on, id) {//on为false的时候，计算为脱下装备 平常的不用 用于处理复杂的装备的问题。
        let afterAttr = this.player.afterAttr;
        switch (id) {
          case 100: {
            ++afterAttr["物理防御"];
            break;
          }

          case 101: {
            ++afterAttr["物理攻击"];
            break;
          }

          case 102: {
            ++afterAttr["法术攻击"];
            break;
          }

          case 103: {
            ++afterAttr["法术防御"];
            break;
          }

          case 104: {
            afterAttr["吸血"] += 0.08;
            break;
          }

          case 105: {
            afterAttr["闪避率"] += 0.01;
            break;
          }
          case 106: {
            afterAttr["暴击率"] += 0.08;
            break;
          }
          case 107: {
            afterAttr["物理攻击"] += 2;
            afterAttr["物理防御"] += 2;
            afterAttr["法术防御"] -= 4;
            break;
          }
          case 108: {
            afterAttr["法术攻击"] += 3;
            afterAttr["闪避率"] -= 0.01;
            break;
          }
          case 109: {
            afterAttr["物理攻击"] += 5;
            afterAttr["物理防御"] -= 2;
            afterAttr["法术防御"] -= 1;
            break;
          }
          case 110: {
            ++afterAttr["物理攻击"];
            ++afterAttr["物理防御"];
            afterAttr["暴击率"] += 0.04;
            break;
          }
          case 111: {
            afterAttr["暴击效果"] += 0.1;
            break;
          }
          case 112: {
            afterAttr["法术攻击"] += 2;
            afterAttr["暴击率"] += 0.03;
            afterAttr["闪避率"] -= 0.01;
            break;
          }
          case 113: {
            afterAttr["法术防御"] += 2;
            afterAttr["物理防御"] += 2;
            afterAttr["闪避率"] -= 0.01;
            break;
          }
          case 114: {
            afterAttr["暴击率"] += 0.1;
            afterAttr["暴击效果"] += 0.1;
            --afterAttr["物理攻击"];
            break;
          }
          case 115: {
            afterAttr["物理攻击"] += 4;
            this.player.health += 10;
            break;
          }
          case 116: {
            ++afterAttr["物理防御"];
            this.player.health += 10;
            break;
          }
          case 117: {
            ++afterAttr["物理防御"];
            afterAttr["闪避率"] += 0.01;
            this.player.health += 20;
            break;
          }
          case 118: {
            afterAttr["物理攻击"] += 6;
            afterAttr["闪避率"] -= 0.03;
            break;
          }
          case 119: {
            afterAttr["物理攻击"] += 15;
            afterAttr["物理防御"] -= 5;
            break;
          }
          case 120: {
            afterAttr["物理攻击"] += 2;
            afterAttr["暴击率"] += 0.1;
            break;
          }
          case 121: {
            --afterAttr["物理攻击"];
            afterAttr["法术防御"] += 3;
            break;
          }
          case 122: {
            afterAttr["法术防御"] += 3;
            afterAttr["暴击率"] -= 0.08;
            break;
          }
          case 123: {
            this.player.health -= 10;
            afterAttr["法术攻击"] += 15;
            break;
          }
          case 124: {
            afterAttr["物理防御"] += 5;
            break;
          }
          case 125: {
            afterAttr["物理攻击"] += 5;
            break;
          }
          case 126: {
            afterAttr["法术攻击"] -= 2;
            afterAttr["吸血"] += 0.2;
            break;
          }
          case 127: {
            afterAttr["物理攻击"] += 3;
            afterAttr["法术攻击"] += 3;
            afterAttr["物理防御"] += 3;
            afterAttr["法术防御"] += 3;
            break;
          }
          case 128: {
            afterAttr["吸血"] -= 0.16;
            afterAttr["法术防御"] += 5;
            break;
          }
          case 129: {
            afterAttr["暴击效果"] -= 0.2;
            afterAttr["法术防御"] += 4;
            afterAttr["物理防御"] += 4;
            break;
          }
          case 130: {
            afterAttr["暴击率"] -= 0.08;
            afterAttr["法术攻击"] -= 2;
            afterAttr["吸血"] += 0.32;
            break;
          }
          case 131: {
            afterAttr["物理攻击"] += 4;
            afterAttr["法术防御"] += 2;
            break;
          }
          case 132: {
            afterAttr["法术攻击"] += 4;
            afterAttr["物理防御"] += 2;
            break;
          }
          case 133: {
            afterAttr["暴击效果"] += 0.2;
            afterAttr["物理攻击"] -= 3;
            break;
          }
          case 134: {
            afterAttr["物理攻击"] += 3;
            afterAttr["法术攻击"] += 3;
            afterAttr["物理防御"] -= 3;
            afterAttr["法术防御"] -= 3;
            break;
          }
          case 135: {
            afterAttr["物理攻击"] -= 3;
            afterAttr["法术攻击"] -= 3;
            afterAttr["物理防御"] += 3;
            afterAttr["法术防御"] += 3;
            break;
          }
          case 136: {
            this.player.health += 70;
            break;
          }
          case 137: {
            afterAttr["闪避率"] += 0.1;
            afterAttr["法术攻击"] += 2;
            break;
          }
          case 138: {
            afterAttr["吸血"] += 0.2;
            afterAttr["法术攻击"] += 8;
            afterAttr["物理防御"] -= 2;
            break;
          }
          case 139: {
            afterAttr["物理防御"] += 8;
            afterAttr["法术防御"] += 8;
            afterAttr["吸血"] -= 0.2;
            break;
          }
          case 140: {
            afterAttr["闪避率"] += 0.1;
            afterAttr["暴击效果"] += 0.3;
            break;
          }
          case 141: {
            afterAttr["暴击率"] += 0.2;
            afterAttr["暴击效果"] += 0.3;
            break;
          }
          case 142: {
            afterAttr["物理防御"] += 10;
            afterAttr["法术防御"] += 10;
            this.player.health += 30;
            break;
          }
          case 143: {
            afterAttr["物理攻击"] += 15;
            afterAttr["法术防御"] += 4;
            break;
          }
          case 144: {
            afterAttr["法术攻击"] += 13;
            afterAttr["物理防御"] += 6;
            break;
          }
          case 145: {
            this.player.health += 100;
            afterAttr["暴击效果"] += 0.3;
            afterAttr["暴击率"] += 0.16;
            break;
          }
          case 146: {
            afterAttr["物理防御"] += 5;
            afterAttr["法术防御"] += 5;
            afterAttr["闪避率"] += 0.08;
            afterAttr["暴击率"] += 0.08;
            afterAttr["暴击效果"] += 0.1;
            break;
          }
          case 147: {
            this.player.equSpecial.id147 = true;
            if (this.player.attr["暴击率"] >= 0.65) {
              this.player.attr["物理攻击"] += 20;
              this.player.attr["法术攻击"] += 20;
            }
            break;
          }
          case 148: {
            afterAttr["物理防御"] += 10;
            afterAttr["法术防御"] += 10;
            this.player.equSpecial.id148 = true;
            break;
          }
          case 149: {
            afterAttr["法术攻击"] += 25;
            this.player.equSpecial.id149 = true;
            break;
          }
          case 150: {
            afterAttr["物理攻击"] += 25;
            this.player.equSpecial.id150 = true;
            break;
          }
          case 151: {
            this.player.health += 100;
            this.player.equSpecial.id151 = true;
            break;
          }
          case 152: {
            this.player.equSpecial.id152 = true;
            break;
          }
          case 153: {
            this.player.equSpecial.id153 = true;
            break;
          }
          case 154: {
            this.player.equSpecial.id154 = true;
            break;
          }

        }

        afterAttr["闪避率"] = this.dealNum(afterAttr["闪避率"]);
        afterAttr["暴击率"] = this.dealNum(afterAttr["暴击率"]);
        afterAttr["吸血"] = this.dealNum(afterAttr["吸血"]);
        afterAttr["暴击效果"] = this.dealNum(afterAttr["暴击效果"]);
      },

      initNextCeng () {
        //初始化下一层的内容。(包括怪物的血量之类的东西)
        //均置血量为最大值 费用为满
        //给上装备上的加成 然后置afterAttr
        this.countEqu();
        this.player.healthNow = this.player.health;
        this.enemy.healthNow = this.enemy.health;
        if (this.player.equSpecial.id154) {
          this.player.feeTotal = 20;
        } else {
          this.player.feeTotal = 10;
        }
        this.player.feeNow = this.player.feeTotal;
      },
      leaveShop () {
        this.isShowShop = false;
        this.isBoom = false;
        //同时为下一层数据初始化
        ++this.cengNum;
        this.id153Used = false;
        this.isJump = false;
        this.showYouLive = false;
        this.enemy.name = getEnemyName()
        this.initNextCeng()
        this.numGetEnemy = '';
        this.numGetPlayer = '';
        this.numPlusEnemy = '';
        this.numPlusPlayer = '';
      },
      shopFresh (money) {
        if (this.player.money < money) {
          alert('钱不够了！');
        } else {
          //t
          axios.post("http://localhost:8083/webase/subbalances/" + this.player.address + "/" + money).then((res) => {
            this.player.money = res.data[0]
            console.log(res.data)
          }).catch((error) => {
            alert(error)
            console.log(error)
          })

          this.player.money = this.player.money - money;
          ++this.freshShopTimes;
          var i;
          var objArr = [];
          objArr = getShopThing(this.lockShopArr, this.player.equList, this.player.skillList, this.cengNum, 4 - this.lockShopArr.length);
          this.shopArr = objArr.concat(this.lockShopArr);
        }
      },
      shopBuyThing (id, type, money) {
        if (this.player.money < money) {
          alert('钱不够！');
          return false;
        } else if (type == "技能" && this.player.skillList.length >= 6) {
          alert('最多拥有6个技能！');
          return false;
        } else if (type === "装备" && this.player.equList.length >= 18) {
          alert('最多拥有18件装备！');
          return false;
        } else {
          // this.player.money -= money;
          axios.post("http://localhost:8083/webase/subbalances/" + this.player.address + "/" + money).then((res) => {
            this.player.money = res.data[0]
            console.log(res.data)
          }).catch((error) => {
            alert(error)
            console.log(error)
          })

          var i
          if (type == "装备") {
            for (i = 0; i < this.shopArr.length; ++i) {
              if (this.shopArr[i].id == id) {
                this.shopLockThing(id, true);//顺带着解锁了
                this.player.equList.push(this.shopArr[i]);
                this.shopArr.splice(i, 1);
                this.countEqu(true);//重新计算装备属性加成
                return true;
              }
            }
          } else {
            //tianjia
            // axios.post()
            console.log(id)
            axios.post("http://localhost:8083/webase/addjineng/" + this.player.address + "/" + id).then((res) => {
              
              console.log(res)
            }).catch((error) => {
              alert(error)
              console.log(error)
            })
            var i;
            for (i = 0; i < this.shopArr.length; ++i) {
                if (this.shopArr[i].id == id) {
                  this.shopLockThing(id, true);
                  this.player.skillList.push(this.shopArr[i]);
                  this.shopArr.splice(i, 1);
                  return true;
                }
              }
          }
        }
      },
      shopLockThing (id, isLock) {
        var obj;
        var i;
        var j;
        if (isLock) {
          for (i = 0; i < this.shopArr.length; ++i) {
            if (this.shopArr[i].id == id) {
              //在商店中展示为已经解锁
              this.shopArr[i].isLock = false;
              //从锁定的数组中除名
              for (j = 0; j < this.lockShopArr.length; ++j) {
                if (this.lockShopArr[j].id == id) {
                  this.lockShopArr.splice(j, 1);
                  return true;
                }
              }
            }
          }
        } else {
          for (i = 0; i < this.shopArr.length; ++i) {
            if (this.shopArr[i].id == id) {
              this.shopArr[i].isLock = true;
              this.lockShopArr.push(this.shopArr[i]);
              return true;
            }
          }
        }

      },
      getShopLockStyle (isLock) {
        if (isLock) {
          return "background-color: gray;"
        } else {
          return "";
        }
      },
      goShop () {//前往商店
        this.initShop()
        this.isShowShop = true
        this.isFightFinish = false
        this.isShowGain = false
        this.isShowEnemyAttr = false
        this.isShowDetail = false
      },
      finishAll () {//已经结束
        if (this.cengNum > localStorage.getItem('max')) {
          localStorage.setItem('max', this.cengNum);
        }
        location.reload();
      },

      //游戏的主要进程控制函数
      // async Main(){
      //   //进入战斗前

      //   //战斗时

      //   //战斗后
      // },

      /*
        现在很多处理函数是事件的绑定函数，因此主要进程函数反而显得不是很重要了。
      */

      startGame () {
        let that = this
        if (this.player.address === "") {
          alert("请输入地址！")
        } else {
          // console.log(this.player.name)
          console.log(this.player.address)
          axios.get("http://localhost:8083/webase/getuser/" + this.player.address).then((res) => {
            this.start = false;
            if (res.data[0] == "") {
              alert("未注册")
            }
            // localStorage.setItem('name', this.player.name);
            this.player.name = res.data[0];
            this.player.money = res.data[2];
            console.log("aaa:" + JSON.parse(res.data[3]).length)
            console.log(skillList.length)
            for (let i = 0; i < skillList.length; i++) {
              for (let k = 0; k < JSON.parse(res.data[3]).length; k++) {
                console.log("i:" + i + " skillList[" + i + "].id" + ":" + skillList[i].id)
                if (skillList[i].id === JSON.parse(res.data[3])[k]) {
                  that.player.skillList.push(skillList[i]);
                }
              }
            }
            console.log(skillList[2])
            console.log(JSON.parse(res.data[3]).length)
            console.log(that.player.skillList)

          }).catch((error) => {
            alert(error)
            console.log(error)
          })


        }
        // this.Main()
      },

      dealNum (num) {//处理函数 
        let str = num.toString();
        if (str[0] === '-') {
          if (str.length > 5) {
            str = str.substring(0, 5);
          }
        } else {
          if (str.length > 4) {
            str = str.substring(0, 4);
          }
        }
        return +str;
      },
    },

    watch: {
      "player.healthNow": {
        handler () {
          if (this.player.healthNow <= 0) {
            if (this.player.equSpecial.id153 && (!this.id153Used)) {
              this.player.healthNow = this.player.health;
              this.id153Used = true;
              this.showYouLive = true;
              setTimeout(() => {
                this.showYouLive = false;
              }, 500);
            } else {
              this.isFightFinish = true;
              this.isShowEnemyAttr = false;
              this.isShowDetail = false;
              this.$refs.yourBlood.style.width = "0%";
            }
          } else {
            this.$refs.yourBlood.style.width = (this.player.healthNow / this.player.health * 100) + "%";
          }
        },
      },
      "enemy.healthNow": {
        handler () {
          if (this.enemy.healthNow <= 0) {
            this.isFightFinish = true;
            this.isShowGain = true
            this.isShowEnemyAttr = false;
            this.isShowDetail = false;
            this.$refs.enemyBlood.style.width = "0%";
          } else {
            this.$refs.enemyBlood.style.width = (this.enemy.healthNow / this.enemy.health * 100) + "%";
          }
        }
      },
    },

    computed: {
      goldGet () {//处理战斗结束之后的金钱获取
        if (this.isFightFinish) {
          let money = Math.floor(this.cengNum * 22 + this.player.healthNow * 0.1);
          axios.post("http://localhost:8083/webase/addbalances/" + this.player.address + "/" + money).then((res) => {
            this.player.money = res.data[0];

            console.log(res)

          }).catch((error) => {
            alert(error)
            console.log(error)
          })
          return money;
        } else {
          return 0;
        }
      },
      attrGet () {//处理战斗结束之后的属性加成
        if (this.isFightFinish) {
          let health = Math.floor(this.cengNum * 9 + this.player.health * 0.08);
          let psAttack = this.cengNum;
          let mgAttack = this.cengNum;
          let psDef = this.cengNum;
          let mgDef = this.cengNum;

          if (this.cengNum <= 5) {
            var Mhealth = Math.floor(this.cengNum * 9.6 + this.player.health * 0.05);
            var MpsAttack = this.cengNum + 1;
            var MmgAttack = this.cengNum + 1;
            var MpsDef = this.cengNum + 1;
            var MmgDef = this.cengNum + 1;
          }

          //给加成双倍的东西留的位置
          let str = ''
          if (this.player.equSpecial.id151) {
            health *= 1.25;
            psAttack *= 1.25;
            mgDef *= 1.25;
            psDef *= 1.25;
            mgAttack *= 1.25;
            health = Math.ceil(health);
            psAttack = Math.ceil(psAttack);
            mgDef = Math.ceil(mgDef);
            psDef = Math.ceil(psDef);
            mgAttack = Math.ceil(mgAttack);
            str = '(已加倍!)'
          }
          //player的自然属性成长 
          this.player.health += health;
          this.player.attr["物理攻击"] += psAttack;
          this.player.attr["法术攻击"] += mgAttack;
          this.player.attr["法术防御"] += mgDef;
          this.player.attr["物理防御"] += psDef;

          this.player.afterAttr["物理攻击"] += psAttack;
          this.player.afterAttr["法术攻击"] += mgAttack;
          this.player.afterAttr["法术防御"] += mgDef;
          this.player.afterAttr["物理防御"] += psDef;

          //enemy的自然属性成长 给随机值
          if (this.cengNum <= 5) {
            this.enemy.health += Mhealth;
            this.enemy.attr["物理攻击"] += MpsAttack;
            this.enemy.attr["法术攻击"] += MmgAttack;
            this.enemy.attr["法术防御"] += MmgDef;
            this.enemy.attr["物理防御"] += MpsDef;
            if (this.enemy.attr["闪避率"] + 0.05 <= 0.12) {
              this.enemy.attr["闪避率"] += 0.05;
              this.enemy.attr["闪避率"] = this.dealNum(this.enemy.attr["闪避率"]);
            }
            if (this.enemy.attr["暴击率"] + 0.05 <= 0.16) {
              this.enemy.attr["暴击率"] += 0.05;
              this.enemy.attr["暴击率"] = this.dealNum(this.enemy.attr["暴击率"]);
            }
            if (this.enemy.attr["吸血"] + 0.05 <= 0.3) {
              this.enemy.attr["吸血"] += 0.05;
              this.enemy.attr["吸血"] = this.dealNum(this.enemy.attr["吸血"]);
            }
          } else {
            this.enemy.health = Math.floor(Math.random() * 41) + this.player.health - 20;
            this.enemy.attr["物理攻击"] = Math.floor(Math.random() * 17) + this.player.afterAttr["物理攻击"] - 8;
            this.enemy.attr["法术攻击"] = Math.floor(Math.random() * 17) + this.player.afterAttr["法术攻击"] - 8;;
            this.enemy.attr["法术防御"] = Math.floor(Math.random() * 17) + this.player.afterAttr["法术防御"] - 8;;
            this.enemy.attr["物理防御"] = Math.floor(Math.random() * 17) + this.player.afterAttr["物理防御"] - 8;
            let rand
            rand = this.dealNum(Math.random()) - 0.3;
            if (rand <= 0.2) {
              this.enemy.attr["闪避率"] = this.dealNum(rand);
            } else {
              this.enemy.attr["闪避率"] = 0.2;
            }
            rand = this.dealNum(Math.random()) - 0.1;
            rand = this.dealNum(rand);
            if (rand <= 0.3) {
              this.enemy.attr["暴击率"] = this.dealNum(rand);
            } else {
              this.enemy.attr["暴击率"] = 0.3;
            }
            rand = this.dealNum(Math.random()) - 0.2;
            rand = this.dealNum(rand);
            if (rand <= 0.3) {
              this.enemy.attr["吸血"] = this.dealNum(rand);
            } else {
              this.enemy.attr["吸血"] = 0.3;
            }
          }

          // this.player.afterAttr = JSON.parse(JSON.stringify(this.player.attr));

          return `最大生命值+${health}，物理攻击+${psAttack}，法术攻击+${mgAttack}，物理防御+${psDef}，法术防御+${mgDef} ${str}`;
        }
      }
    }
  };
  var skillList = [
    {
      id: 200,
      name: "普通一拳",
      desc: "造成等同于你的'物理伤害'点物理伤害",
      quality: "普通",
      type: "技能",
      buy: 19,
      cost: 3,
      isLock: false,
    },
    {
      id: 201,
      name: "普通格挡",
      desc: "在本局对战中获得+10%'物理防御'",
      quality: "普通",
      type: "技能",
      buy: 19,
      cost: 3,
      isLock: false,
    },
    {
      id: 202,
      name: "普通法球",
      desc: "造成等同于你的'法术伤害'点法术伤害",
      quality: "普通",
      type: "技能",
      buy: 19,
      cost: 3,
      isLock: false,
    },
    {
      id: 203,
      name: "普通防护",
      desc: "在本局对战中获得+10%'法术防御'",
      quality: "普通",
      type: "技能",
      buy: 19,
      cost: 3,
      isLock: false,
    },
    {
      id: 204,
      name: "嗜血",
      desc: "你的下一次攻击额外获得0.5的吸血效果",
      quality: "普通",
      type: "技能",
      cost: 6,
      buy: 50,
      isLock: false,
    },
    {
      id: 205,
      name: "回复术",
      desc: "回复4.5%最大生命值 点生命值",
      quality: "普通",
      type: "技能",
      cost: 1,
      buy: 26,
      isLock: false,
    },
    {
      id: 206,
      name: "怒火中烧",
      desc: "你的下一次物理攻击必定暴击",
      quality: "普通",
      type: "技能",
      cost: 5,
      buy: 65,
      isLock: false,
    },
    {
      id: 207,
      name: "削弱",
      desc: "在本局对战中减少对手10%'物理攻击'点'物理攻击'",
      quality: "普通",
      type: "技能",
      cost: 4,
      buy: 40,
      isLock: false,
    },
    {
      id: 208,
      name: "破防",
      desc: "在本局对战中减少对手10%'物理防御'点'物理防御'",
      quality: "普通",
      type: "技能",
      cost: 4,
      buy: 40,
      isLock: false,
    },
    {
      id: 209,
      name: "恐吓",
      desc: "在本局对战中减少对手10%'法术防御'点'法术防御'",
      quality: "普通",
      type: "技能",
      cost: 4,
      buy: 40,
      isLock: false,
    },
    {
      id: 210,
      name: "嘲讽",
      desc: "在本局对战中减少对手10%'法术攻击'点'法术攻击'",
      quality: "普通",
      type: "技能",
      cost: 4,
      buy: 40,
      isLock: false,
    },
    {
      id: 211,
      name: "无蓄力一拳",
      desc: "造成等同于你的'物理攻击'*0.65的物理伤害",
      quality: "普通",
      type: "技能",
      buy: 24,
      cost: 2,
      isLock: false,
    },
    {
      id: 212,
      name: "无蓄力冲击",
      desc: "造成等同于你的'法术攻击'*0.65的法术伤害",
      quality: "普通",
      type: "技能",
      buy: 24,
      cost: 2,
      isLock: false,
    },
    {
      id: 213,
      name: "双重叠甲",
      desc: "在本局对战中获得+10%基础物理防御，+10%基础法术防御",
      quality: "普通",
      type: "技能",
      cost: 3,
      buy: 66,
      isLock: false,
    },
    {
      id: 214,
      name: "盾反",
      desc: "造成等同于自身'物理防御'点数的物理伤害",
      quality: "稀有",
      type: "技能",
      buy: 60,
      cost: 4,
      isLock: false,
    },
    {
      id: 215,
      name: "另类的盾反",
      desc: "造成等同于自身'物理防御'点数的法术伤害",
      quality: "稀有",
      type: "技能",
      cost: 4,
      buy: 60,
      isLock: false,
    },
    {
      id: 216,
      name: "篷反",
      desc: "造成等同于自身'法术防御'点数的法术伤害",
      quality: "稀有",
      type: "技能",
      cost: 4,
      buy: 60,
      isLock: false,
    },
    {
      id: 217,
      name: "另类的篷反",
      desc: "造成等同于自身'法术防御'点数的物理伤害",
      quality: "稀有",
      type: "技能",
      cost: 4,
      buy: 60,
      isLock: false,
    },
    {
      id: 218,
      name: "血誓诅咒",
      desc: "你的下一次攻击获得的吸血效果翻倍",
      quality: "稀有",
      type: "技能",
      cost: 2,
      buy: 80,
      isLock: false,
    },
    {
      id: 219,
      name: "闪避",
      desc: "直到你的下回合，你的闪避+0.2",
      quality: "稀有",
      type: "技能",
      cost: 4,
      buy: 65,
      isLock: false,
    },
    {
      id: 220,
      name: "法术核心",
      desc: "直到你的下回合，你的对手的法术攻击对你无效",
      quality: "稀有",
      type: "技能",
      buy: 92,
      cost: 6,
      isLock: false,
    },
    {
      id: 221,
      name: "物理核心",
      desc: "直到你的下回合，你的对手的物理攻击对你无效",
      quality: "稀有",
      type: "技能",
      cost: 6,
      buy: 92,
      isLock: false,
    },
    {
      id: 222,
      name: "大记忆恢复术",
      desc: "将你的生命值恢复至其上个回合时的状态",
      quality: "史诗",
      type: "技能",
      cost: 7,
      buy: 468,
      isLock: false,
    },
    {
      id: 223,
      name: "超模的恢复术",
      desc: "恢复自身20%点最大生命值，并在本局获得+5%基础物理防御，+5%基础法术防御",
      quality: "史诗",
      type: "技能",
      cost: 8,
      buy: 168,
      isLock: false,
    },
    {
      id: 224,
      name: "神圣洗礼",
      desc: "消耗你剩余的行动力，被消耗的行动力会留到下个回合供你使用。",
      quality: "史诗",
      type: "技能",
      cost: 0,
      buy: 446,
      isLock: false,
    },
    {
      id: 225,
      name: "冬日寒霜",
      desc: "直到你的下回合，你受到的伤害减半。",
      quality: "史诗",
      type: "技能",
      cost: 6,
      buy: 308,
      isLock: false,
    },
    {
      id: 226,
      name: "永恒祭祀",
      desc: "交换你与对手的生命值(不会超过生命值上限)",
      quality: "神话",
      type: "技能",
      cost: 5,
      buy: 750,
      isLock: false,
    },
    {
      id: 227,
      name: "造物奇迹",
      desc: "回复你的所有生命值，对你的对手造成等同于你回复的生命值的50%的法术伤害。",
      quality: "神话",
      type: "技能",
      cost: 10,
      buy: 800,
      isLock: false,
    },
    {
      id: 228,
      name: "八方云雨",
      desc: "你的下一次伤害无视防御。",
      quality: "神话",
      type: "技能",
      cost: 0,
      buy: 750,
      isLock: false,
    },
    {
      id: 229,
      name: "虚空融合",
      desc: "直到你的下个回合，你获得免疫。",
      quality: "传说",
      type: "技能",
      cost: 10,
      buy: 600,
      isLock: false,
    },
    {
      id: 230,
      name: "破碎次元",
      desc: "消灭你的对手",
      quality: "传说",
      type: "技能",
      cost: 30,
      buy: 600,
      isLock: false,
    },
  ]
  //当前设计 55个 3传说(152-154) 5神话(147-151) 8史诗(138-146) 14稀有(124-137) 24普通(100-123)
  //普通性价为-1 稀有为-2 史诗为-3
  // 装备列表
  var equipmentList = [
    {
      id: 100,
      name: "布甲",
      desc: "物理防御+1",
      quality: "普通",
      type: "装备",
      buy: 16,
      isLock: false,
    },
    {
      id: 101,
      name: "铁剑",
      desc: "物理攻击+1",
      quality: "普通",
      type: "装备",
      buy: 14,
      isLock: false,
    },
    {
      id: 102,
      name: "魔石",
      desc: "法术攻击+1",
      quality: "普通",
      type: "装备",
      buy: 18,
      isLock: false,
    },
    {
      id: 103,
      name: "防护项链",
      desc: "法术防御+1",
      quality: "普通",
      type: "装备",
      buy: 19,
      isLock: false,
    },
    {
      id: 104,
      name: "渊狱石碎片",
      desc: "吸血+0.08",
      quality: "普通",
      type: "装备",
      buy: 24,
      isLock: false,
    },
    {
      id: 105,
      name: "闪影靴",
      desc: "闪避率+0.01",
      quality: "普通",
      type: "装备",
      buy: 23,
      isLock: false,
    },
    {
      id: 106,
      name: "暴怒之戒",
      desc: "暴击率+0.08",
      quality: "普通",
      type: "装备",
      buy: 24,
      isLock: false,
    },
    {
      id: 107,
      name: "荆棘板甲",
      desc: "物理攻击+2，物理防御+2，法术防御-4",
      quality: "普通",
      type: "装备",
      buy: 32,
      isLock: false,
    },
    {
      id: 108,
      name: "呓语水晶球",
      desc: "法术攻击+3，闪避率-0.01",
      quality: "普通",
      type: "装备",
      buy: 30,
      isLock: false,
    },
    {
      id: 109,
      name: "破碎的君主之刃",
      desc: "物理攻击+5，物理防御-2，法术防御-1",
      quality: "普通",
      type: "装备",
      buy: 19,
      isLock: false,
    },
    {
      id: 110,
      name: "破碎的上古戒指",
      desc: "物理攻击+1，物理防御+1，暴击率+0.04",
      quality: "普通",
      type: "装备",
      buy: 40,
      isLock: false,
    },
    {
      id: 111,
      name: "血腥棘刺",
      desc: "暴击效果+0.1",
      quality: "普通",
      type: "装备",
      buy: 15,
      isLock: false,
    },
    {
      id: 112,
      name: "迷人的伪装",
      desc: "法术攻击+2，暴击率+0.03，闪避率-0.01",
      quality: "普通",
      type: "装备",
      buy: 24,
      isLock: false,
    },
    {
      id: 113,
      name: "碧玉核心",
      desc: "法术防御+2，物理防御+2，闪避率-0.01",
      quality: "普通",
      type: "装备",
      buy: 46,
      isLock: false,
    },
    {
      id: 114,
      name: "不祥护腕",
      desc: "暴击率+0.1，暴击效果+0.1，物理攻击-1",
      quality: "普通",
      type: "装备",
      buy: 38,
      isLock: false,
    },
    {
      id: 115,
      name: "开山刀",
      desc: "物理攻击+4，最大生命值+10",
      quality: "普通",
      type: "装备",
      buy: 63,
      isLock: false,
    },
    {
      id: 116,
      name: "护心甲",
      desc: "最大生命值+10，物理防御+1",
      quality: "普通",
      type: "装备",
      buy: 32,
      isLock: false,
    },
    {
      id: 117,
      name: "镜面甲",
      desc: "物理防御+1，闪避率+0.01，最大生命值+20",
      quality: "普通",
      type: "装备",
      buy: 82,
      isLock: false,
    },
    {
      id: 118,
      name: "闪烁的长矛",
      desc: "物理攻击+6，闪避率-0.03",
      quality: "普通",
      type: "装备",
      buy: 60,
      isLock: false,
    },
    {
      id: 119,
      name: "辉耀圣剑的残柄",
      desc: "物理攻击+15，物理防御-5",
      quality: "普通",
      type: "装备",
      buy: 35,
      isLock: false,
    },
    {
      id: 120,
      name: "啸风巨狼之牙",
      desc: "物理攻击+2，暴击率+0.1",
      quality: "普通",
      type: "装备",
      buy: 51,
      isLock: false,
    },
    {
      id: 121,
      name: "庇护之甲",
      desc: "法术防御+3，物理攻击-1",
      quality: "普通",
      type: "装备",
      buy: 42,
      isLock: false,
    },
    {
      id: 122,
      name: "和平戒指",
      desc: "法术防御+3，暴击率-0.08",
      quality: "普通",
      type: "装备",
      buy: 32,
      isLock: false,
    },
    {
      id: 123,
      name: "异端之杖",
      desc: "最大生命值-10，法术攻击+15",
      quality: "普通",
      type: "装备",
      buy: 40,
      isLock: false,
    },
    {
      id: 124,
      name: "硬甲",
      desc: "物理防御+5",
      quality: "稀有",
      type: "装备",
      buy: 42,
      isLock: false,
    },
    {
      id: 125,
      name: "巨剑",
      desc: "物理攻击+5",
      quality: "稀有",
      type: "装备",
      buy: 40,
      isLock: false,
    },
    {
      id: 126,
      name: "禁断之牙",
      desc: "法术攻击-2，吸血+0.2",
      quality: "稀有",
      type: "装备",
      buy: 16,
      isLock: false,
    },
    {
      id: 127,
      name: "万金油",
      desc: "物理攻击+3，法术攻击+3，物理防御+3，法术防御+3",
      quality: "稀有",
      type: "装备",
      buy: 68,
      isLock: false,
    },
    {
      id: 128,
      name: "祖咒封印",
      desc: "吸血-0.16，法术防御+5",
      quality: "稀有",
      type: "装备",
      buy: 28,
      isLock: false,
    },
    {
      id: 129,
      name: "绝情护甲",
      desc: "暴击效果-0.2，法术防御+4，物理防御+4",
      quality: "稀有",
      type: "装备",
      buy: 42,
      isLock: false,
    },
    {
      id: 130,
      name: "棘背巨龙之鳞",
      desc: "暴击率-0.08，法术攻击-2，吸血+0.32",
      quality: "稀有",
      type: "装备",
      buy: 60,
      isLock: false,
    },
    {
      id: 131,
      name: "清风剑",
      desc: "物理攻击+4，法术防御+2",
      quality: "稀有",
      type: "装备",
      buy: 82,
      isLock: false,
    },
    {
      id: 132,
      name: "魔精法杖",
      desc: "法术攻击+4，物理防御+2",
      quality: "稀有",
      type: "装备",
      buy: 84,
      isLock: false,
    },
    {
      id: 133,
      name: "耀斑鸟之眼",
      desc: "暴击效果+0.2，物理攻击-3",
      quality: "稀有",
      type: "装备",
      buy: 25,
      isLock: false,
    },
    {
      id: 134,
      name: "霜雪之咬",
      desc: "物理攻击+3，法术攻击+3，物理防御-3，法术防御-3",
      quality: "稀有",
      type: "装备",
      buy: 12,
      isLock: false,
    },
    {
      id: 135,
      name: "焰炙之赐",
      desc: "物理防御+3，法术防御+3，物理攻击-3，法术攻击-3",
      quality: "稀有",
      type: "装备",
      buy: 12,
      isLock: false,
    },
    {
      id: 136,
      name: "不死图腾",
      desc: "最大生命值+70",
      quality: "稀有",
      type: "装备",
      buy: 100,
      isLock: false,
    },
    {
      id: 137,
      name: "春日祈祷",
      desc: "闪避率+0.1，法术攻击+2",
      quality: "稀有",
      type: "装备",
      buy: 90,
      isLock: false,
    },
    {
      id: 138,
      name: "渊狱花",
      desc: "吸血+0.2，法术攻击+8，物理防御-2",
      quality: "史诗",
      type: "装备",
      buy: 95,
      isLock: false,
    },
    {
      id: 139,
      name: "末日裂隙之铠",
      desc: "物理防御+8，法术防御+8，吸血-0.2",
      quality: "史诗",
      type: "装备",
      buy: 100,
      isLock: false,
    },
    {
      id: 140,
      name: "彼岸斗篷",
      desc: "闪避率+0.1，暴击效果+0.3",
      quality: "史诗",
      type: "装备",
      buy: 100,
      isLock: false,
    },
    {
      id: 141,
      name: "光阴之手",
      desc: "暴击率+0.2，暴击效果+0.3",
      quality: "史诗",
      type: "装备",
      buy: 124,
      isLock: false,
    },
    {
      id: 142,
      name: "北境统领之甲",
      desc: "物理防御+10，法术防御+10，最大生命值+30",
      quality: "史诗",
      type: "装备",
      buy: 256,
      isLock: false,
    },
    {
      id: 143,
      name: "斩圣之剑",
      desc: "物理攻击+15，法术防御+4",
      quality: "史诗",
      type: "装备",
      buy: 236,
      isLock: false,
    },
    {
      id: 144,
      name: "摄魂之杖",
      desc: "法术攻击+13，物理防御+6",
      quality: "史诗",
      type: "装备",
      buy: 236,
      isLock: false,
    },
    {
      id: 145,
      name: "旧日遗忘",
      desc: "最大生命值+100，暴击效果+0.3，暴击率+0.16",
      quality: "史诗",
      type: "装备",
      buy: 230,
      isLock: false,
    },
    {
      id: 146,
      name: "颂唱者",
      desc: "法术防御+5，物理防御+5，闪避率+0.08，暴击率+0.08，暴击效果+0.1",
      quality: "史诗",
      type: "装备",
      buy: 190,
      isLock: false,
    },
    {
      id: 147,
      name: "末日号角",
      desc: "装备后：你的攻击必定暴击。若是装备时暴击率已经不小于0.65，则额外永久获得：物理攻击+20，法术攻击+20。(即出售后仍有效)",
      quality: "神话",
      type: "装备",
      buy: 420,
      isLock: false,
    },
    {
      id: 148,
      name: "辉映重铠",
      desc: "物理防御+10，法术防御+10。装备后：你受到的攻击永久减少50%，向上取整。",
      quality: "神话",
      type: "装备",
      buy: 550,
      isLock: false,
    },
    {
      id: 149,
      name: "冰封圣杖",
      desc: "法术攻击+25。装备后：如果你造成的攻击数值为偶数，则点击结束回合后跳过对手的下回合。",
      quality: "神话",
      type: "装备",
      buy: 550,
      isLock: false,
    },
    {
      id: 150,
      name: "试锋",
      desc: "物理攻击+25，装备后：你造成的攻击不会被闪避。",
      quality: "神话",
      type: "装备",
      buy: 300,
      isLock: false,
    },
    {
      id: 151,
      name: "彼岸之镜",
      desc: "最大生命值+100。装备后：你的自然属性成长变为原来的1.25倍。",
      quality: "神话",
      type: "装备",
      buy: 280,
      isLock: false,
    },
    {
      id: 152,
      name: "八角琉璃盏",
      desc: "装备后：如果你连续5个回合没有受到伤害，那么在第六回合，消灭你的对手。",
      quality: "传说",
      type: "装备",
      buy: 600,
      isLock: false,
    },
    {
      id: 153,
      name: "渊狱王冠",
      desc: "装备后：每场对战限一次，死亡后立刻满状态复活。",
      quality: "传说",
      type: "装备",
      buy: 600,
      isLock: false,
    },
    {
      id: 154,
      name: "寂灭虚空",
      desc: "装备后：你的最大行动点数变为20点。",
      quality: "传说",
      type: "装备",
      buy: 600,
      isLock: false,
    },
  ]
  function getEnemyName () {
    var mode = Math.floor(Math.random() * 4); //产生0-3的随机数
    var rev = Math.floor(Math.random() * 2) === 1 ? true : false; //产生true/false
    var length = Math.floor(Math.random() * 5 + 1); //产生1-5之间的随机数
    if (length == 1) {
      ++length;
    }

    var mode0Arr = [
      ["碎", "吞", "逐", "御", "困", "灭", "屠", "斩", "牧"],
      ["星", "圣", "雷", "恶", "罚", "元", "龙", "灭", "灵"],
      "者"
    ];//xx者
    var mode1Arr = [
      ["白", "赤", "青", "银", "霜", "炎", "影"],
      ["袍", "矛", "刃", "枪", "锤", "弓", "盾"]
    ];//xx
    var mode2Arr = [
      ["永恒", "光耀", "创世", "无畏", "暗耀", "归一", "寂灭"],
      ["雷霆", "狱火", "山岳", "奇点", "辉腾", "憎恶", "毒泽"]
    ];//xxxx
    var mode3Arr = [
      ["梅捷洛斯", "阿亚伐尔", "莫德兹", "临冬堡", "迪斯卡丹", "莫里尖峰", "渊狱"],
      "之",
      ["心", "殇", "王", "盾", "刃", "手", "主"]
    ];//xx之x
    var nameArr = [
      ["梅", "阿", "斯", "勃", "莫", "罗", "敏"],
      ["兹", "卡", "丹", "洛", "维", "里", "英"],
      ["玛", "伦", "诺", "森", "安", "尔", "多"],
      ["捷", "基", "索", "布", "希", "夫", "姆"],
      ["艾", "萨", "拉", "法", "奥", "列", "特"],
      ["库", "拉", "顿", "格", "德", "琳", "克"],
      ["桑", "托", "米", "尼", "亚", "瑟", "威"]
    ];
    var name = "";
    let i = 0;
    var nameIndex1;
    var nameIndex2;

    //47 64 79 92 102 119
    switch (mode) {
      case 0: {
        if (rev) {
          for (i = 0; i < length; ++i) {
            nameIndex1 = Math.floor(Math.random() * 7);
            nameIndex2 = Math.floor(Math.random() * 7);
            name += nameArr[nameIndex1][nameIndex2];
          }
          name += ",";
          nameIndex1 = Math.floor(Math.random() * 9);
          nameIndex2 = Math.floor(Math.random() * 9);
          name += mode0Arr[0][nameIndex1];
          name += mode0Arr[1][nameIndex2];
          name += mode0Arr[2];
        } else {
          nameIndex1 = Math.floor(Math.random() * 9);
          nameIndex2 = Math.floor(Math.random() * 9);
          name += mode0Arr[0][nameIndex1];
          name += mode0Arr[1][nameIndex2];
          name += mode0Arr[2];
          for (i = 0; i < length; ++i) {
            nameIndex1 = Math.floor(Math.random() * 7);
            nameIndex2 = Math.floor(Math.random() * 7);
            name += nameArr[nameIndex1][nameIndex2];
          }
        }

        return name;
      }

      case 1: {
        nameIndex1 = Math.floor(Math.random() * 7);
        nameIndex2 = Math.floor(Math.random() * 7);
        name += mode1Arr[0][nameIndex1];
        name += mode1Arr[1][nameIndex2];
        for (i = 0; i < length; ++i) {
          nameIndex1 = Math.floor(Math.random() * 7);
          nameIndex2 = Math.floor(Math.random() * 7);
          name += nameArr[nameIndex1][nameIndex2];
        }
        return name;
      }

      case 2: {
        nameIndex1 = Math.floor(Math.random() * 7);
        nameIndex2 = Math.floor(Math.random() * 7);
        name += mode2Arr[0][nameIndex1];
        name += mode2Arr[1][nameIndex2];
        for (i = 0; i < length; ++i) {
          nameIndex1 = Math.floor(Math.random() * 7);
          nameIndex2 = Math.floor(Math.random() * 7);
          name += nameArr[nameIndex1][nameIndex2];
        }
        return name;
      }

      case 3: {
        if (rev) {
          for (i = 0; i < length; ++i) {
            nameIndex1 = Math.floor(Math.random() * 7);
            nameIndex2 = Math.floor(Math.random() * 7);
            name += nameArr[nameIndex1][nameIndex2];
          }
          name += ",";
          nameIndex1 = Math.floor(Math.random() * 7);
          nameIndex2 = Math.floor(Math.random() * 7);
          name += mode3Arr[0][nameIndex1];
          name += mode3Arr[1];
          name += mode3Arr[2][nameIndex2];
        } else {
          nameIndex1 = Math.floor(Math.random() * 7);
          nameIndex2 = Math.floor(Math.random() * 7);
          name += mode3Arr[0][nameIndex1];
          name += mode3Arr[1];
          name += mode3Arr[2][nameIndex2];
          for (i = 0; i < length; ++i) {
            nameIndex1 = Math.floor(Math.random() * 7);
            nameIndex2 = Math.floor(Math.random() * 7);
            name += nameArr[nameIndex1][nameIndex2];
          }
        }

        return name;
      }

      default:
        return "你的敌人"
    }
  }


</script>

<style scoped>
  @import '../style/index.css';
  @import '../style/shopPage.css';
  @import '../style/startPage.css';

  .good {
    padding: 0;
    margin: 0;
    height: 100%;
    width: 100%;
    overflow-x: hidden;
  }

  .top {
    position: relative;
    top: 0;
    left: 0;
    width: 100vw;
    height: 20vh;
    min-height: 200px;
    background-color: #0f66bb;
    border-bottom: 1px solid black;
  }

  .top-title {
    font-size: 5rem;
    height: 100%;
    display: flex;
    color: white;
    justify-content: center;
    align-items: center;
  }

  .mid {
    position: relative;
    top: 0;
    left: 0;
    width: 100%;
    height: 30%;
    min-width: 30rem;
  }

  .mid-content {
    height: 10vh;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .mid-toLogin {
    width: auto;
    height: auto;
    /* border: 3px solid red; */
    margin: 0 auto;
    padding: 0.5rem;
    font-size: 3rem;
    text-decoration: none;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #0f66bb;
    border-bottom: 0.3rem solid #0f66bb;
  }

  .bottom {
    position: relative;
    top: 0;
    left: 0;
    width: 100%;
    height: 30%;
    min-width: 30rem;
    background-color: whitesmoke;
  }

  .bottom-content {
    width: auto;
    height: auto;
    /* border: 3px solid red; */
    margin: 0 auto;
    padding: 0.5rem;
    font-size: 3rem;
    text-decoration: none;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;

  }
</style>