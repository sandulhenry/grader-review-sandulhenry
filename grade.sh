CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [ -f "student-submission/ListExamples.java" ]; then
    echo "File found!"
else
    echo "ListExamples.java not found!"
    exit 1
fi

# jars
cp -r lib grading-area
#list examples
cp student-submission/ListExamples.java grading-area/
# testListExamples
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ]; then
    echo "Compile Error!"
    exit 1
else 
    echo "Compiled Successfully"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt
if [ $? == 0 ]; then
    echo "Perfect Pass"
    echo "Score: 100%"
    exit 0
else 
    lastline=$(cat output.txt | tail -n 2 | head -n 1)
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$(($tests -$failures))

    echo ""
    echo "Tests ran: $tests"
    echo "Tests failed: $failures"

    echo "Score is $(expr $successes / $tests)"
fi
