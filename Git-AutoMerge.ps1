<# 

	.SYNOPSIS 
	
		Automatically merge the given source branch into the destination branch

	.DESCRIPTION 
		
		The Git-AutoMerge function merge the branch source into the destination branch
		only if the merge is fast-forward. It pushes the resulting commit if the merge succeed.
		Otherwise it aborts the merge to restore a clean state.
	
	.PARAMETER remote

		The name of the remote repository

	.PARAMETER source

		The branch to merge into the destination branch.

	.PARAMETER destination
		
		The branch in which the changes made in the source branch will be replayed since it diverged.

	.EXAMPLE 

		Merges the Story123 branch into the dev branch and pushes the result onto the origin distant repository.

		Git-AutoMerge origin Story123 dev

	.NOTES

		This scripts runs only if the following assumptions are fulfilled :
			- The current directory must be a git repository
			- Git should be installed and in your PATH
			- The remote origin exists

#>
function Git-AutoMerge([string]$remote, [string]$source, [string]$destination)
{ 
	function Git-Checkout([string]$branch) { 
		$currentBranch = git rev-parse --abbrev-ref HEAD
		if($destination -ne $currentBranch) { 
			git checkout $destination
		}
	}

    Git-Checkout($destination)

	git pull $remote $destination
    git merge $remote/$source

    if($LASTEXITCODE -eq 0) 
    { 
        git push $remote $destination
    } 
    elseif($LASTEXITCODE -eq 1) 
    { 
        git merge --abort
    }
}

