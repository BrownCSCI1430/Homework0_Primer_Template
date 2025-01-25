%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CSCI 1430 Homework --- document setup
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesClass{csci1430}[2025/01/25 CSC1430 LaTeX Questions v0.1]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass[11pt]{article}

\usepackage[english]{babel}
\usepackage[utf8]{inputenc}
\usepackage{amssymb}
\usepackage{xcolor}
\usepackage[colorlinks = true,
            linkcolor = blue,
            urlcolor  = blue]{hyperref}
\usepackage[a4paper,margin=1.5in]{geometry}
\usepackage{stackengine,graphicx}
\usepackage{fancyhdr}
\setlength{\headheight}{15pt}
\usepackage{microtype}
\usepackage{times}
\usepackage[shortlabels]{enumitem}
\setlist[enumerate]{topsep=0pt}
\usepackage{amsmath}
\usepackage{framed}
\usepackage{mdframed}
\usepackage{xcolor}
\usepackage[most]{tcolorbox}

% setup for todo lists:
\usepackage{enumitem}
\newlist{todolist}{itemize}{2}
\setlist[todolist]{label=$\square$}
\usepackage{pifont}
\newcommand{\cmark}{\ding{51}}%
\newcommand{\done}{\rlap{$\square$}{\raisebox{2pt}{\large\hspace{1pt}\cmark}}%
\hspace{-2.5pt}}

% a great python code format: https://github.com/olivierverdier/python-latex-highlighting
\usepackage{pythonhighlight}

\usepackage{trimclip,lipsum}
%\usepackage{xparse}

\frenchspacing
\setlength{\parindent}{0cm} % Default is 15pt.
\setlength{\parskip}{0.3cm plus1mm minus1mm}

%%
% Orange / green boxes
%%

\newcounter{question}[section]
\newcounter{subquestion}[subsection]
\newcounter{subsubquestion}[subsubsection]

\ExplSyntaxOn

% Define variables globally
\int_new:N \l_question_points_int
\int_new:N \l_answer_height_int
\bool_new:N \l_question_drawbox_bool
\tl_new:N \l_question_points_str
\tl_new:N \l_question_pointpoints_str

% Questions: Define key-value options handler globally
\keys_define:nn { question }
{
    points   .int_set:N = \l_question_points_int,
    drawbox  .bool_set:N = \l_question_drawbox_bool,
}
% Plus its defaults
\keys_set:nn { question } { points = 0, drawbox = true }

% Answers: Define key-value options handler globally
\keys_define:nn { answer }
{
    height   .int_set:N = \l_answer_height_int,
}
% Plus its defaults
\keys_set:nn { answer } { height = 0 }

\NewDocumentEnvironment{orangebox}{}
{
    \begin{tcolorbox}[colback=orange!5!white,colframe=orange!75!black]
}{
    \end{tcolorbox}
}

% Define the new document environment
\NewDocumentEnvironment{question}{O{}}
{
    % Define local scope to this environment
    \group_begin: 

    % Reset counters
    \setcounter{subquestion}{0}
    \setcounter{subsubquestion}{0}

    \addtocounter{question}{1}

    % Parse parameter key/values
    \keys_set:nn { question } { #1 }

    % Define either "point" or "points" string depending on
    % whether the number of points is equal to 1
    \int_compare:nNnTF { \l_question_points_int } = { 1 } 
    { \tl_set:Nn \l_question_pointpoints_str {point} } 
    { \tl_set:Nn \l_question_pointpoints_str {points} }

    % If the number of points is greater than 0, the define a string for the number of points next to the question.
    \int_compare:nNnTF { \l_question_points_int } > { 0 } 
    { \tl_set:Nx \l_question_points_str {~---~[ \int_use:N \l_question_points_int \ \str_use:N \l_question_pointpoints_str ]} }
    { \tl_set:Nx \l_question_points_str {:} }

    \par\medskip\noindent\textbf{
        % Write "Q" then the question number + points string
        Q\thequestion \str_use:N \l_question_points_str
    }
    \bool_if:NTF \l_question_drawbox_bool
    { \begin{orangebox} }
    {\newline}
}
{
    \bool_if:NT \l_question_drawbox_bool
    { \end{orangebox} }

    % End local scope
    \group_end:
}

\NewDocumentEnvironment{subquestion} { O{} }
{    
    % Define local scope to this environment
    \group_begin: 

    % Handle counters
    \setcounter{subsubquestion}{0}
    \addtocounter{subquestion}{1}

    % Parse parameter key/values
    \keys_set:nn { question } { #1 }

    % Define either "point" or "points" string depending on
    % whether the number of points is equal to 1
    \int_compare:nNnTF { \l_question_points_int } = { 1 } 
    { \str_set:Nn \l_question_pointpoints_str {point} } 
    { \str_set:Nn \l_question_pointpoints_str {points} }

    % If the number of points is greater than 0, the define a string for the number of points next to the question.
    \int_compare:nNnTF { \l_question_points_int } > { 0 } 
    { \tl_set:Nx \l_question_points_str {~---~[ \int_use:N \l_question_points_int \ \str_use:N \l_question_pointpoints_str ]} }
    { \tl_set:Nx \l_question_points_str {:} }

    \par\medskip\noindent\textbf{
        % Write "Q" then the question number
        Q\thequestion.\thesubquestion \str_use:N \l_question_points_str
    }
    \bool_if:NTF \l_question_drawbox_bool
    { \begin{tcolorbox}[colback=orange!5!white,colframe=orange!75!black] }
    {\newline}
}
{
    \bool_if:NT \l_question_drawbox_bool
    { \end{tcolorbox} }

    % End local scope
    \group_end:
}

\NewDocumentEnvironment{subsubquestion} { O{} }
{
    % Define local scope to this environment
    \group_begin: 

    % Handle counters
    \int_compare:nNnT { \thesubquestion } = { 0 }
    { \addtocounter{subquestion}{1} }
    \addtocounter{subsubquestion}{1}

    % Parse parameter key/values
    \keys_set:nn { question } { #1 }

    % Define either "point" or "points" string depending on
    % whether the number of points is equal to 1
    \int_compare:nNnTF { \l_question_points_int } = { 1 } 
    { \str_set:Nn \l_question_pointpoints_str {point} } 
    { \str_set:Nn \l_question_pointpoints_str {points} }

    % If the number of points is greater than 0, the define a string for the number of points next to the question.
    \int_compare:nNnTF { \l_question_points_int } > { 0 } 
    { \tl_set:Nx \l_question_points_str {~---~[ \int_use:N \l_question_points_int \ \str_use:N \l_question_pointpoints_str ]} }
    { \tl_set:Nx \l_question_points_str {:} }

    \par\medskip\noindent\textbf{
        % Write "Q" then the question number
        Q\thequestion.\thesubquestion.\thesubsubquestion \str_use:N \l_question_points_str
    }
    \bool_if:NTF \l_question_drawbox_bool
    { \begin{tcolorbox}[colback=orange!5!white,colframe=orange!75!black] }
    {\newline}
}{
    \bool_if:NT \l_question_drawbox_bool
    { \end{tcolorbox} }

    % End local scope
    \group_end:
}

\NewDocumentEnvironment{answer} { O{} }
{
    \group_begin:
    \keys_set:nn { answer } { #1 }

    % Define the fixed dimensions for clipping
    \def\clip_height { 1.2\l_answer_height_int\baselineskip }
    
    % Set up a temporary box to hold the content
    \setbox0=\hbox\bgroup

    \int_compare:nNnTF { \l_answer_height_int } > { 0 }
    {
        \begin{tcolorbox}[colback=white!5!white,colframe=green!75!black,height=\l_answer_height_int\baselineskip]
    }{
        \begin{tcolorbox}[colback=white!5!white,colframe=green!75!black]
    }
}{
    \end{tcolorbox}

    % Finish the box and clip it to the specified height
    \egroup
    \clipbox{0pt \dimexpr\ht0-\clip_height\relax{} 0pt 0pt}
      { \copy0 }

    \group_end:
}

\NewDocumentEnvironment{answerlist} { O{} }
{
    \group_begin:

    \begin{answer}
    \begin{todolist}[itemsep=0pt]
}{
    \end{todolist}
    \end{answer}

    \group_end:
}


\ExplSyntaxOff


\date{}
\author{CSCI 1430}

\pagestyle{fancy}
\fancyhf{}
\lhead{HW0}
\rhead{CSCI1430}

\lfoot{\textcolor{red}{\textbf{Only}
\ifcase\thepage
\or \textbf{instructions}
\or \textbf{Q1}
\or \textbf{Q2}
\or \textbf{Q3}
\or \textbf{Q4.1.1}
\or \textbf{Q4.1.2}
\or \textbf{Q4.2.1}
\or \textbf{Q4.2.2}
\or \textbf{Q5.1 and Q5.2.1}
\or \textbf{Q5.2.2 and Q5.3}
\or \textbf{Q6}
\or \textbf{Q6}
\or \textbf{Q7}
\or \textbf{Q7}
\or \textbf{feedback}
\else
\textbf{[ERROR: PAGE MISALIGNMENT]}
\fi
\textbf{should be on this page}
}}
\rfoot{\thepage~/ 15}