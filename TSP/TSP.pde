import java.util.Arrays;

int[][] m = {
  {Integer.MAX_VALUE, 21, 7, 13, 15}, // A
  {11, Integer.MAX_VALUE, 19, 12, 25}, // B
  {15, 24, Integer.MAX_VALUE, 13, 5}, // C
  {6, 17, 9, Integer.MAX_VALUE, 22}, // D
  {28, 6, 11, 5, Integer.MAX_VALUE}      // E
};

String[] names = {"A", "B", "C", "D", "E"};

void setup() {
  judge(0, 0);
}

void draw() {
  noLoop();
}

ArrayList<Integer> findMinCost() {
  int minValue = Integer.MAX_VALUE;
  int minI = -1;
  int minJ = -1;

  for (int i=0; i<m.length; i++) {
    for (int j=0; j<m[0].length; j++) {
      if (minValue > m[i][j]) {
        minValue = m[i][j];
        minI = i;
        minJ = j;
      }
    }
  }

  return new ArrayList<Integer>(Arrays.asList(minI, minJ));
}

void judge(int currentCost, int counter) {
  // 分枝の方法での枝刈りは4回まで
  if (counter == 4) {
    return;
  }

  //  コスト最小のエッジを探す
  int start = -1;
  int end = -1;
  int min = Integer.MAX_VALUE;
  for (int i=0; i<m.length; i++) {
    for (int j=0; j<m[0].length; j++) {
      if (min > m[i][j]) {
        start = i;
        end = j;
        min = m[i][j];
      }
    }
  }

  //  作業用配列にコピー
  int[][] mTrue = new int[m.length][m[0].length];
  int[][] mFalse = new int[m.length][m[0].length];
  for (int i=0; i<mTrue.length; i++) {
    for (int j=0; j<mTrue[0].length; j++) {
      mTrue[i][j] = m[i][j];
      mFalse[i][j] = m[i][j];
    }
  }

  // start-end を通る場合用にstart行とend列を無効化
  // ここを通るコストは別に加算する
  for (int i=0; i<m.length; i++) {
    mTrue[start][i] = Integer.MAX_VALUE;
    mTrue[i][end] = Integer.MAX_VALUE;
  }
  // start-endを通らない場合用に該当コストを最大化
  mFalse[start][end] = Integer.MAX_VALUE;

  // それぞれの場合でコストを計算
  int costTrue = calcCost(mTrue) + currentCost + m[start][end];
  println(names[start] + "-" + names[end] + "を通る時の下界: " + costTrue);
  int costFalse = calcCost(mFalse) + currentCost;
  println(names[start] + "-" + names[end] + "を通らない時の下界: " + costFalse);

  if (costTrue < costFalse) {
    // この道は通るという判断
    int thisCost = m[start][end];
    for (int i=0; i<m.length; i++) {
      m[start][i] = Integer.MAX_VALUE;
      m[i][end] = Integer.MAX_VALUE;
    }
    println("\t->" + names[start] + "-" + names[end] + "を通る");

    judge(currentCost+thisCost, ++counter);
  } else {
    // この道は通らないという判断
    m[start][end] = Integer.MAX_VALUE;
    println("\t->" + names[start] + "-" + names[end] + "を通らない");

    judge(currentCost, ++counter);
  }
}

int calcCost(int[][] matrix) {
  int ret = 0;

  // 行方向の計算
  for (int i=0; i<matrix.length; i++) {
    int min = matrix[i][0];
    for (int j=1; j<matrix[0].length; j++) {
      if (min > matrix[i][j]) {
        min = matrix[i][j];
      }
    }

    if (min == Integer.MAX_VALUE) {
      continue;
    }

    ret += min;
    for (int j=0; j<matrix[0].length; j++) {
      if (matrix[i][j] == Integer.MAX_VALUE) {
        continue;
      }
      matrix[i][j] -= min;
    }
  }

  // 列方向の計算
  for (int j=0; j<matrix[0].length; j++) {
    int min = matrix[0][j];
    for (int i=1; i<matrix.length; i++) {
      if (min > matrix[i][j]) {
        min = matrix[i][j];
      }
    }

    if (min == Integer.MAX_VALUE) {
      continue;
    }

    ret += min;
    for (int i=0; i<matrix.length; i++) {
      if (matrix[i][j] == Integer.MAX_VALUE) {
        continue;
      }
      matrix[i][j] -= min;
    }
  }

  return ret;
}
