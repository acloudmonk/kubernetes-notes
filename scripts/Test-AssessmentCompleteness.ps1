[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repositoryRoot = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw 'Run this script from inside the repository.'
}

$failures = [System.Collections.Generic.List[string]]::new()
$checkedModules = 0

Get-ChildItem (Join-Path $repositoryRoot 'curriculum') -Directory |
    Where-Object { $_.Name -match '^\d{2}-' } |
    Sort-Object Name |
    ForEach-Object {
        $module = $_
        $interviewPath = Join-Path $module.FullName 'interview-questions.md'
        $quizPath = Join-Path $module.FullName 'quiz.md'

        if (-not (Test-Path $interviewPath) -or -not (Test-Path $quizPath)) {
            $failures.Add("$($module.Name): missing interview-questions.md or quiz.md")
            return
        }

        $interview = Get-Content -Raw $interviewPath
        $questions = [regex]::Matches($interview, '(?m)^###\s+\d+\.\s+\S').Count
        $answers = [regex]::Matches($interview, '(?m)^\*\*Answer:\*\*\s+\S').Count

        if ($questions -eq 0 -or $questions -ne $answers) {
            $failures.Add("$($module.Name): interview questions=$questions, explicit answers=$answers")
        }

        $quiz = Get-Content -Raw $quizPath
        $answerHeading = [regex]::Match($quiz, '(?m)^## Answers\s*$')
        if (-not $answerHeading.Success) {
            $failures.Add("$($module.Name): quiz has no visible '## Answers' section")
        }
        else {
            $promptText = $quiz.Substring(0, $answerHeading.Index)
            $answerText = $quiz.Substring($answerHeading.Index + $answerHeading.Length)
            $quizQuestions = [regex]::Matches($promptText, '(?m)^\d+\.\s+\S').Count
            $quizAnswers = [regex]::Matches($answerText, '(?m)^\d+\.\s+\S').Count

            if ($quizQuestions -eq 0 -or $quizQuestions -ne $quizAnswers) {
                $failures.Add("$($module.Name): quiz questions=$quizQuestions, answers=$quizAnswers")
            }
        }

        $checkedModules++
    }

if ($failures.Count -gt 0) {
    Write-Error ("Assessment completeness failed:`n- " + ($failures -join "`n- "))
    exit 1
}

Write-Output "Assessment completeness: PASS ($checkedModules modules checked)"
