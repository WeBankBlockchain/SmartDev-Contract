package main

import (
	"fmt"
	"math"
	"math/big"
	"math/rand"
	"os"
	"strconv"
	"time"
)

var (
	eta int 	// 安全参数η
	p uint64	// 对称密钥
	q *big.Int	// 参数
)

func main()  {
	if len(os.Args) <= 1 {
		panic("Please input parameters η")
	}
	//	为了防止q的溢出，q是64位则η<=4,q是256位则η<=6 (η^3 < 位数)
	eta, _ = strconv.Atoi(os.Args[1]) 		//  测试得出： η >= 9 加法、乘法计算稳定
	fmt.Println("η = ", eta)
	fmt.Printf("p range is [%d, %d)\n", int(math.Pow(float64(2), float64(eta-1))), int(math.Pow(float64(2), float64(eta))))
	for i := 0; i < 100; i++ {
		rand.Seed(time.Now().UnixNano() + int64(i))
		// 生成密钥
		fmt.Println("p = ", genKey_p())
		// 生成参数q
		fmt.Printf("q = %d\n", genPara_q())
		//genPara_q()
		// 加密测试
		m0, m1 := uint(0), uint(1)
		fmt.Printf("m0 = %d, m1 = %d\n", m0, m1)
		c0 := Encrypto(m0)
		c1 := Encrypto(m1)
		//fmt.Printf("c0 = %d, c1 = %d\n", c0, c1)
		// 解密
		n0, n1 := Decrypto(c0), Decrypto(c1)
		fmt.Printf("解密结果：n0 = %d, n1 = %d\n", n0, n1)
		// 评估
		// 加法测试
		fmt.Printf("加法测试：%d + %d , %v\n", m0, m1, EvaluateAdd(m0, m1, c0, c1))
		fmt.Printf("加法测试：%d + %d , %v\n", m0, m0, EvaluateAdd(m0, m0, c0, c0))
		fmt.Printf("加法测试：%d + %d , %v\n", m1, m1, EvaluateAdd(m1, m1, c1, c1))
		fmt.Printf("加法测试：%d + %d , %v\n", m1, m0, EvaluateAdd(m1, m0, c1, c0))
		fmt.Println("==============================================")
		// 乘法测试
		fmt.Printf("乘法测试：%d * %d , %v\n", m0, m1, EvaluateMul(m0, m1, c0, c1))
		fmt.Printf("乘法测试：%d * %d , %v\n", m0, m0, EvaluateMul(m0, m0, c0, c0))
		fmt.Printf("乘法测试：%d * %d , %v\n", m1, m1, EvaluateMul(m1, m1, c1, c1))
		fmt.Printf("乘法测试：%d * %d , %v\n", m1, m0, EvaluateMul(m1, m0, c1, c0))
		fmt.Println("==============================================")
	}
}

func genKey_p() uint64 {
	// p ∈ [2^(η−1), 2^η) and odd
	for {
		randomP := int(math.Pow(float64(2), float64(eta-1))) + rand.Intn(int(math.Pow(float64(2), float64(eta-1))))
		if randomP % 2 == 1 {
			p = uint64(randomP)
			return p
		}
	}
}

func genPara_r() int64 {
	// |2r| < p/2
	//  r ≈ 2^(√η)
	goal := int(math.Pow(2, math.Sqrt(float64(eta))))
	r := 2
	randr := goal - r + 2 * rand.Intn(r)
	for int(math.Abs(float64(2 * randr))) >= int(p) / 2 {
		rand.Seed(time.Now().UnixNano())
		randr = goal - r + 2 * rand.Intn(r)
	}
	//fmt.Println("r = ", randr)
	return int64(randr)
}

func genPara_q() *big.Int {
	// q ≈ 2^(η^3)
	goal := big.NewInt(1)
	for i := 0; i < int(math.Pow(float64(eta), 3)); i++ {
		goal.Mul(goal, big.NewInt(2))
	}
	r := 100
	goal.Sub(goal, big.NewInt(int64(r)))
	goal.Add(goal, big.NewInt(int64(2 * rand.Intn(r))))
	q = goal
	return q
}

func Encrypto(m uint) *big.Int {
	r := genPara_r()
	c := big.NewInt(int64(m) + 2*r)
	mul := q.Mul(q, big.NewInt(int64(p)))
	c.Add(c, mul)
	return c
}

func Decrypto(c *big.Int) uint64 {
	mod := &big.Int{}
	mod = mod.Mod(c, big.NewInt(int64(p)))
	mod.Mod(mod, big.NewInt(2))
	return mod.Uint64()
}

func EvaluateAdd(m0, m1 uint, c0, c1 *big.Int) bool {
	c := &big.Int{}
	c.Add(c0, c1)
	n := Decrypto(c)
	if m0 == 1 && m1 == 1 {
		return n == 0
	}
	return n == uint64(m0 + m1)
}

func EvaluateMul(m0, m1 uint, c0, c1 *big.Int) bool {
	c := &big.Int{}
	c.Mul(c0, c1)
	n := Decrypto(c)
	return n == uint64(m0 * m1)
}