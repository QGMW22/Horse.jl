using LearningHorse
using Test

@testset "LearningHorse.jl" begin
    mean = LossFunction.MSE([1,2,3,4], [1,2,3,4], [1,2])
    @test mean == 4
    for (a, x) in zip(1:2, [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], [1 2 3 4 5; 2 3 4 5 6]])
        sd = Preprocessing.SS.fit_transform(x, axis = a)
        inv = Preprocessing.SS.inverse_transform(sd[1], sd[2], axis = a)
        p = Preprocessing.SS.fit(x, axis = a)
        @test Preprocessing.SS.transform(x, p, axis = a) == sd[1]
        sd = Preprocessing.MM.fit_transform(x, axis = a)
        inv = Preprocessing.MM.inverse_transform(sd[1], sd[2], axis = a)
        p = Preprocessing.MM.fit(x, axis = a)
        @test Preprocessing.MM.transform(x, p, axis = a) == sd[1]
        sd = Preprocessing.RS.fit_transform(x, axis = a)
        inv = Preprocessing.RS.inverse_transform(sd[1], sd[2], axis = a)
        p = Preprocessing.RS.fit(x, axis = a)
        @test Preprocessing.RS.transform(x, p, axis = a) == sd[1]
    end
    x = [15.43 23.01 5.0 12.56 8.67 7.31 9.66 13.64 14.92 18.47 15.48 22.13 10.11 26.95 5.68 21.76]
    t = [170.91 160.68 129.0 159.7 155.46 140.56 153.65 159.43 164.7 169.65 160.71 173.29 159.31 171.52 138.96 165.87]
    w =LinearRegression.SGD.fit(x, t)
    p = LinearRegression.SGD.predict(x, w)
    println(typeof(p), p)
    @test 1 < w[1] < 2
    @test 100 < w[2]
    x =[15.43 23.01 5.0 12.56 8.67 7.31 9.66 13.64 14.92 18.47 15.48 22.13 10.11 26.95 5.68 21.76; 70.43 58.15 37.22 56.51 57.32 40.84 57.79 56.94 63.03 65.69 62.33 64.95 57.73 66.89 46.68 61.08]
    t = [170.91 160.68 129.0 159.7 155.46 140.56 153.65 159.43 164.7 169.65 160.71 173.29 159.31 171.52 138.96 165.87]
    w = LinearRegression.MR.fit(x, t)
    println(typeof(w))
    p = LinearRegression.MR.predict(x, w)
    print(p)
    w = LinearRegression.RR.fit(x, t)
    p = LinearRegression.RR.predict(x, w)
    w = LinearRegression.LR.fit(x, t)
    println(w)
    p = LinearRegression.LR.predict(x, w)
    println(p)
    w, m, s = LinearRegression.BFM.fit(x[1, :], t, 4)
    println("w:", w, "m:", m, "s:", s)
    p = LinearRegression.BFM.predict(x[1, :], w, m, s)
    println(p)
    mse = LossFunction.MSE(x[1, :], t, w, b = "gauss", m = m, s = s)
    println(mse)
    w, m, s = LinearRegression.BFM.fit(x[1, :], t, 4, alpha = 0.1, f = "polynomial")
    println("p(polynomial):", p)
    p = LinearRegression.BFM.predict(x[1, :], w, m, s, f = "polynomial")
    println("p:", p)
    mse = LossFunction.MSE(x[1, :], t, w, b = "polynomial", m = m, s = s)
    x = [5.1 3.5; 4.9 3.0; 4.7 3.2; 4.6 3.1; 5.0 3.6; 5.4 3.9; 4.6 3.4; 5.0 3.4; 4.4 2.9; 4.9 3.1; 5.4 3.7; 4.8 3.4; 4.8 3.0; 4.3 3.0; 5.8 4.0; 5.7 4.4; 5.4 3.9; 5.1 3.5; 5.7 3.8; 5.1 3.8; 5.4 3.4; 5.1 3.7; 4.6 3.6; 5.1 3.3; 4.8 3.4; 5.0 3.0; 5.0 3.4; 5.2 3.5; 5.2 3.4; 4.7 3.2; 4.8 3.1; 5.4 3.4; 5.2 4.1; 5.5 4.2; 4.9 3.1; 5.0 3.2; 5.5 3.5; 4.9 3.6; 4.4 3.0; 5.1 3.4; 5.0 3.5; 4.5 2.3; 4.4 3.2; 5.0 3.5; 5.1 3.8; 4.8 3.0; 5.1 3.8; 4.6 3.2; 5.3 3.7; 5.0 3.3; 7.0 3.2; 6.4 3.2; 6.9 3.1; 5.5 2.3; 6.5 2.8; 5.7 2.8; 6.3 3.3; 4.9 2.4; 6.6 2.9; 5.2 2.7; 5.0 2.0; 5.9 3.0; 6.0 2.2; 6.1 2.9; 5.6 2.9; 6.7 3.1; 5.6 3.0; 5.8 2.7; 6.2 2.2; 5.6 2.5; 5.9 3.2; 6.1 2.8; 6.3 2.5; 6.1 2.8; 6.4 2.9; 6.6 3.0; 6.8 2.8; 6.7 3.0; 6.0 2.9; 5.7 2.6; 5.5 2.4; 5.5 2.4; 5.8 2.7; 6.0 2.7; 5.4 3.0; 6.0 3.4; 6.7 3.1; 6.3 2.3; 5.6 3.0; 5.5 2.5; 5.5 2.6; 6.1 3.0; 5.8 2.6; 5.0 2.3; 5.6 2.7; 5.7 3.0; 5.7 2.9; 6.2 2.9; 5.1 2.5; 5.7 2.8; 6.3 3.3; 5.8 2.7; 7.1 3.0; 6.3 2.9; 6.5 3.0; 7.6 3.0; 4.9 2.5; 7.3 2.9; 6.7 2.5; 7.2 3.6; 6.5 3.2; 6.4 2.7; 6.8 3.0; 5.7 2.5; 5.8 2.8; 6.4 3.2; 6.5 3.0; 7.7 3.8; 7.7 2.6; 6.0 2.2; 6.9 3.2; 5.6 2.8; 7.7 2.8; 6.3 2.7; 6.7 3.3; 7.2 3.2; 6.2 2.8; 6.1 3.0; 6.4 2.8; 7.2 3.0; 7.4 2.8; 7.9 3.8; 6.4 2.8; 6.3 2.8; 6.1 2.6; 7.7 3.0; 6.3 3.4; 6.4 3.1; 6.0 3.0; 6.9 3.1; 6.7 3.1; 6.9 3.1; 5.8 2.7; 6.8 3.2; 6.7 3.3; 6.7 3.0; 6.3 2.5; 6.5 3.0; 6.2 3.4; 5.9 3.0]
    t = [0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2]
    tree, classes = Tree.DT.fit(x, t)
    println(tree)
    p = Tree.DT.predict(x, tree, classes)
    println(p)
    #=forest, classes, using_feature = Ensemble.RF.fit(x, t)
    println("learning ended")
    p = Ensemble.RF.predict(x, forest, classes, using_feature)
    println(p)=#
    label = ["Apple", "Apple", "Pear", "Pear", "Lemon", "Apple", "Pear", "Lemon"]
    l = Classification.LE(label)
    println(l)
    t = Classification.CTOH(t)
    w = Classification.MS.fit(x, t, alpha = 0.1)
    println(w)
    p = Classification.MS.predict(x, w)
    println(p)
    cee = LossFunction.CEE(x, t, w, t_f = true)
    println(cee)
    w = Classification.OVR.fit(x, t; alpha = 0.1)
    println("w:", w)
    p = Classification.OVR.predict(x, w)
    println("predict:", p)
    cee = LossFunction.CEE(x, t, w, sigmoid_f = true)
    println("cee:", cee)
end
